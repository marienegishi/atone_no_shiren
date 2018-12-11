require 'rails_helper'
RSpec.describe Card_api do

    describe 'judge' do
      context 'validを通過しなかった場合' do
        before do
          post :judge, params: {card_form: {hands:"H1 H1 H3 H3 H5"}}
        end
        it 'エラーメッセージが表示される' do
          expect(@result).to eq nil
        end
      end
      context 'validを通過した場合' do
        before do
          post :judge, params: {card_form: {hands:"C7 C6 C5 C4 C3"}}
          @card_form = HomeController.new
          @result = @card_form.judge
        end
        it '役が表示される' do
          expect(@result).to eq "ストレートフラッシュ"
        end
      end
      context 'handsに値が入力された場合' do
        before do
          post :judge, params: {card_form: {hands:"C10 S10 S6 H4 H2"}}
          @card_form = HomeController.new
          @response = @card_form.judge
        end
        it '/newページにリダイレクトさせる' do
          expect(@response).to true
        end
      end
    end
end
