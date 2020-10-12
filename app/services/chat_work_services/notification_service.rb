class ChatWorkServices::NotificationService
  attr_reader :cmd, :cmd_message, :input_errors, :notification

  VALIDATION_INPUT = %i(cmd cmd_message)
  INPUT_ERRORS = {
    cmd: "Sai command line",
    cmd_message: "Sai nội dung"
  }
  ALLOWED_FIELDS = %w(schedule_type title_name noti_content scheduled_at_date scheduled_at_time)

  def initialize noti, options={}
    @cmd = noti[:str]
    @cmd_message = noti[:cmd_message]
    @notification = Notification.new
  end

  def exec_cmd
    return json_errors input_errors if input_validation
    handle_notification
  end

  private

  def input_validation
    @input_errors = VALIDATION_INPUT.map{|v| {v => INPUT_ERRORS[v]} if v.empty?}
    @input_errors.compact.present?
  end

  def json_errors errors
    {
      errors: errors
    }
  end

  def handle_notification
    params = noti_params
    return json_errors notification.errors.messages if notification.errors.any?
    params.merge!(merge_create_params) if :create === cmd.to_sym
    Notification.send(cmd.to_sym, params)
  end

  def noti_params
    return add_noti_errors :base, :invalid_template_format unless template_validation
    # existed_fields = []
    @next_idx = -1
    params = cmd_message.dup.map.with_index do |str, idx|
      dir_tmp_file = Dir.glob("/tmp/noti_message_temp*.txt").first
      field, val = str.split("=")

      next if idx <= next_idx
      next if !field.in?(ALLOWED_FIELDS) && dir_tmp_file.blank?
      # next if field == "[code]" || field == "[/code]"

      cal_val = if field.in?(ALLOWED_FIELDS) && val.present?
                  # existed_fields.push field
                  val.match?(/\A(xstart)/) ? build_multiline_content(idx + 1) : val
                end
      [field, cal_val]
    end.to_h.symbolize_keys
    params[:noti_content] = cmd_message.
    begin
      str_datetime = params[:scheduled_at_date]
      str_datetime << " " << params[:scheduled_at_time]
      params[:scheduled_at] = str_to_datetime str_datetime
    rescue => e
      add_noti_errors :scheduled_at, :invalid_datetime, message: e
    end
  end

  def build_multiline_content idx
    cmd_message.slice(idx + 1, cmd_message.length - 1)
      .each_with_index.reduce("") do |tmp_mess, (str, inx)|
        break if str.match?(/\A(xend)/)
        @next_idx = inx + 1
        tmp_mess << str
    end
  end

  def merge_create_params
    {
      creator_id: User.normal.chatwork.find_by_ref_chat_account Digest::MD5.hexdigest(options[:account_id])
    }
  end

  def add_noti_errors field, error_name, message=nil
    notification.errors.add(field, error_name, message: message) if message
    notification.errors.add field, error_name
  end

  def template_validation
    cmd_message[0] == "[code]" && cmd_message[cmd_message.length - 1] == "[/code]"
  end

  def str_to_datetime str
    str << " #{Time.now.getlocal.zone}"
    DateTime.parse(str).utc
  end
end
