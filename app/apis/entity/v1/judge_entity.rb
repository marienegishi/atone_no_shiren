
module Entity
  module V1
    class Judge_Entity < Grape::Entity
      # {"message_boards":[]}
      # {"message_board":{} }
      # というJSON出力になります。
      root 'result'

      expose :card, :hand, :best
      # 値を加工することができる。
      # expose :updated_at do |result|
      #   result.updated_at.strftime#("%Y-%m-%d %H:%M:%S")
      # end
      #
      # # 他のEntityの定義を使うことができる。
      # expose :comments, using: 'Entity::V1::CommentsEntity'
      #
      # expose(:comment_count) do |message_board|
      #   message_board.comments.count(:id)
      # end
    end
  end
end

# module Entity
#   module V1
#     class Card_apiEntity < Grape::Entity
#       # {"comments":[]}
#       # というJSON出力になります。
#       root 'comments'
#
#       expose :card, :hand, :best
#     end
#   end
# end

