# Rspec(テスト)やるよ
require 'rails_helper'

RSpec.describe CardForm do
# 他のServiceClassで定義してたメソッドを呼び出すよ
# 入力された値が手札だよって定義する
  describe 'initialize' do
    before do
      hands = "D1 D10 S9 C5 C4"
      @card_form = CardForm.new(hands)
      @error_messages = []
    end
    it 'handsに値が入力されてるか' do
      expect(@card_form.hands).to eq "D1 D10 S9 C5 C4"
    end
  end

# バリデーション
  describe 'valid?' do
    context '入力値が間違っている場合' do
      context '入力値にカード4枚分のみ入力された場合' do
        before do
          hands = "H1 H2 H3 H4"
          @card_form = CardForm.new(hands)
          @result = @card_form.valid?
        end
        it 'falseを返す' do
          expect(@result).to eq false
        end
        it 'error_messagesにバリデーションメッセージが格納される' do
          expect(@card_form.error_messages).to eq ["半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"]
        end
      end

      context '入力値が重複している場合' do
        before do
          hands = "H1 H1 H3 H3 H5"
          @card_form = CardForm.new(hands)
          @result = @card_form.valid?
        end
        it 'falseを返す' do
          expect(@result).to eq false
        end
        it 'error_messagesにバリデーションメッセージが格納される' do
          expect(@card_form.error_messages).to eq ["カードが重複しています。"]
        end

        context '入力値に13以上の数字が入力されている場合' do
          before do
            hands = "H1 H2 H3 H4 H14"
            @card_form = CardForm.new(hands)
            @result = @card_form.valid?
          end
          it 'falseを返す' do
            expect(@result).to eq false
          end
          it 'error_messagesにバリデーションメッセージが格納される' do
            expect(@card_form.error_messages).to eq ["半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"]
          end
        end
        context '入力値がアルファベットと数字のセットになっていない場合' do
          before do
            hands = "H1 H2 H3 H4 HH"
            @card_form = CardForm.new(hands)
            @result = @card_form.valid?
          end
          it 'falseを返す' do
            expect(@result).to eq false
          end
          it 'error_messagesにバリデーションメッセージが格納される' do
            expect(@card_form.error_messages).to eq ["半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"]
          end
        end
        context '入力値にSHDC以外のアルファベットが入力されている場合' do
          before do
            hands = "H1 H2 H3 H4 A1"
            @card_form = CardForm.new(hands)
            @result = @card_form.valid?
          end
          it 'falseを返す' do
            expect(@result).to eq false
          end
          it 'error_messagesにバリデーションメッセージが格納される' do
            expect(@card_form.error_messages).to eq ["半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"]
          end
        end
      end
    end
  end

# 役判定
  YAKU = ["ハイカード", "ワンペア", "ツーペア", "スリー・オブ・ア・カインド", "ストレート", "フラッシュ", "フルハウス", "フォー・オブ・ア・カインド", "ストレートフラッシュ"]
  describe 'judge' do

    context 'ハイカードの場合' do
      before do
        hands = "D1 D10 S9 C5 C4"
        @card_form = CardForm.new(hands)
        @result = @card_form.judge
      end
      it '"ハイカード"を返す' do
        expect(@result).to eq YAKU[0]
      end
    end
    context 'ワンペアの場合' do
      before do
        hands = "C10 S10 S6 H4 H2"
        @card_form = CardForm.new(hands)
        @result = @card_form.judge
      end
      it '"ワンペア"を返す' do
        expect(@result).to eq YAKU[1]
      end
    end
    context 'ツーペアの場合' do
      before do
        hands = "H13 D13 C2 D2 H11"
        @card_form = CardForm.new(hands)
        @result = @card_form.judge
      end
      it '"ツーペア"を返す' do
        expect(@result).to eq YAKU[2]
      end
    end
    context 'スリー・オブ・ア・カインドの場合' do
      before do
        hands = "S12 C12 D12 S5 C3"
        @card_form = CardForm.new(hands)
        @result = @card_form.judge
      end
      it '"スリー・オブ・ア・カインド"を返す' do
        expect(@result).to eq YAKU[3]
      end
    end
    context 'ストレートの場合' do
      before do
        hands = "S8 S7 H6 H5 S4 "
        @card_form = CardForm.new(hands)
        @result = @card_form.judge
      end
      it '"ストレート"を返す' do
        expect(@result).to eq YAKU[4]
      end
    end
    context 'フラッシュの場合' do
      before do
        hands = "H1 H12 H10 H5 H3"
        @card_form = CardForm.new(hands)
        @result = @card_form.judge
      end
      it '"フラッシュ"を返す' do
        expect(@result).to eq YAKU[5]
      end
    end
    context 'フルハウスの場合' do
      before do
        hands = "S10 H10 D10 S4 D4"
        @card_form = CardForm.new(hands)
        @result = @card_form.judge
      end
      it '"フルハウス"を返す' do
        expect(@result).to eq YAKU[6]
      end
    end
    context 'フォー・オブ・ア・カインドの場合' do
      before do
        hands = "C10 D10 H10 S10 D5"
        @card_form = CardForm.new(hands)
        @result = @card_form.judge
      end
      it '"フォー・オブ・ア・カインド"を返す' do
        expect(@result).to eq YAKU[7]
      end
    end
    context 'ストレートフラッシュの場合' do
      before do
        hands = "C7 C6 C5 C4 C3"
        @card_form = CardForm.new(hands)
        @result = @card_form.judge
      end
      it '"ストレートフラッシュ"を返す' do
        expect(@result).to eq YAKU[8]
      end
    end
  end
end
