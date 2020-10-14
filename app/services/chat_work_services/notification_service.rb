class ChatWorkServices::NotificationService
  attr_reader :cmd, :cmd_message, :input_errors, :options, :user
  attr_accessor :notification

  VALIDATION_INPUT = %i(cmd cmd_message)
  INPUT_ERRORS = {
    cmd: "Sai command line",
    cmd_message: "Sai nội dung",
    user_not_allowed: "Bạn chưa có quyền thao tác với notification! (leuleu)"
  }

  ALLOWED_FIELDS = %w(schedule_type title_name noti_content scheduled_at)

  def initialize noti, options={}
    @options = options
    @cmd = noti[:str]
    @cmd_message = noti[:cmd_message]
    @notification = Notification.new
    @user = User.normal.chatwork.find_by_ref_chat_account Digest::MD5.hexdigest(options[:account_id])
  end

  def exec_cmd
    return json_errors({user_not_allowed: [INPUT_ERRORS[:user_not_allowed]]}) unless user
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
    }.as_json
  end

  def handle_notification
    params = noti_params
    return json_errors notification.errors.messages if notification.errors.any?
    params.merge!(merge_create_params) if :create === cmd.to_sym
    self.send("#{cmd}!", params)
  rescue ActiveRecord::RecordInvalid
    json_errors notification.errors.messages
  end

  def create! params
    notification.assign_attributes params
    notification.save!
    notification.as_json
  end

  def load_notification params
    @notification = user.notifications.find_by_title_name params[:title_name]
  end


  def update! params
    load_notification params
    return find params, :update unless notification
    create! params
  end

  def delete! params
    load_notification params
    return find params, :delete unless notification
  end

  def find params, s_action=nil
    found_data = user.notifications.select(:title_name)
      .where("title_name LIKE ?", "%#{params[:title_name].slice(0, 10)}%")
    return found_data.as_json unless s_action
    {
      alert: "Không tìm thấy notification cần #{s_action} của bạn! (?)",
      suggestions: found_data.as_json.presence || "Bạn chưa tạo notification nào!"
    }.as_json
  end

  def noti_params
    return add_noti_errors :base, :invalid_template_format unless template_validation
    @next_idx = -1
    begin
      data = cmd_message.dup.map.with_index do |str, idx|
        field, val = str.split("=")
        next if idx < @next_idx

        if field.in?(ALLOWED_FIELDS) && val.present?
          val = val.match?(/\A(xstart)/) ? build_multiline_content(idx) : build_field_value(field, val)
          [field, val]
        end
      end.compact.to_h.symbolize_keys
    rescue => err
      add_noti_errors :base, :invalid_field_data, err
    end
  end

  def build_multiline_content idx
    tmp_mess = ""
    cmd_message[idx + 1..- 1].each_with_index do |str, inx|
      @next_idx = idx + inx
      break if str.match?(/\A(xend)/)
      tmp_mess << "#{str}\n"
    end
    tmp_mess
  end

  def build_field_value field, val
    return val if "scheduled_at" != field

    val.squish.split(",").map do |str_datetime|
      str_to_datetime str_datetime
    end
  end

  def merge_create_params
    {
      creator_id: user.id
    }
  end

  def add_noti_errors field, error_name, message=nil
    return notification.errors.add(field, error_name, message: message) if message
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
