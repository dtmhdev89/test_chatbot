class ChatWorkServices::ApiSearchServices
  attr_accessor :analyzed_list, :rep_message

  def initialize analyzed_list
    @analyzed_list = analyzed_list
    @rep_message = CommonKeyWordApiSearch::Messages.new
  end

  def search
    get_data_for_analyzed_list
  end

  private

  def get_data_for_analyzed_list
    mess = "";
    analyzed_list.dup.map do |searchObj|
      mess = rep_message.send(searchObj[:key].to_sym, searchObj[:str])
      break if mess
    end
    mess
  end
end
