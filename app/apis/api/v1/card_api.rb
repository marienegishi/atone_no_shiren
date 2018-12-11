module API
  module V1
    class Card_api < Grape::API
      format :json
      resource :card_api do
        CONTENT_TYPE = "application/json"

        group do
          params do
            requires :cards #レスポンス変えるところ

          end
          post '/' do
            @error = []
            @result = []

            params[:cards].each do |card|
              # p card
              card_form = CardForm.new(card)
              if card_form.valid? == false
                @error << {card: card, msg: card_form.error_messages}
                # p @error, with: Entity::V1::Valid_Entity
              else
                card_form.judge
                @result << {card: card, hand: card_form.yaku, best: card_form.strength}
              end
            end
            a = []
            @result.each do |i|
              a << i[:best]
            end
            @result.each do |r|
              if r[:best] == a.max
                r[:best] = "true"
              else
                r[:best] = "false"
              end
            end
            {"result": @result,"error": @error}
          end
        end
      end
    end
  end
end
