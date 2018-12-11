class CardForm
  attr_accessor :hands, :error_messages, :yaku, :strength
  include ActiveModel::Model

  YAKU = ["ハイカード", "ワンペア", "ツーペア", "スリー・オブ・ア・カインド", "ストレート", "フラッシュ", "フルハウス", "フォー・オブ・ア・カインド", "ストレートフラッシュ"].freeze

  def initialize(hands = nil)
    @hands = hands
    @error_messages = []
    @suits = []
    @numbers = []
    @yaku = nil
    @strength = nil
  end

  # 入力できる内容かバリデーションを判定する
  def valid?
    hands = @hands.split

    # 5こセットである
    if hands.count != 5
      @error_messages << "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
      return false
    end
    # 重複してない
    if hands.uniq.count != 5
      @error_messages << "カードが重複しています。"
      return false
    end
    # 数字とアルファベットのセット、数字が13以下である
    hands.each do |hand|
      if (/(S|H|D|C)([1-9]|1[0-3])$/.match(hand)).nil?
        @error_messages << "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
        return false
      end
    end
    return true
  end

  #役の判断。


  def judge
    hands = @hands.split

    #それそれのカードから、スートの部分だけ、数字の部分だけを取り出した配列を別に作る。
    hands.each do |c|
      @suits << c[0]
      @numbers << c[1..-1].to_i
    end

    case same_number_counts
    # ロイヤルストレートフラッシュは入れない
    when [2, 1, 1, 1]
      @yaku = YAKU[1]
      @strength = 1
    when [2, 2, 1]
      @yaku = YAKU[2]
      @strength = 2
    when [3, 1, 1]
      @yaku = YAKU[3]
      @strength = 3
    when [3, 2]
      @yaku = YAKU[6]
      @strength = 6
    when [4, 1]
      @yaku = YAKU[7]
      @strength = 7
    else
      case [straight?, flush?]
      when [true, false]
        @yaku = YAKU[4]
        @strength = 4
      when [false, true]
        @yaku = YAKU[5]
        @strength = 5
      when [true, true]
        @yaku = YAKU[8]
        @strength = 8
      else
        @yaku = YAKU[0]
        @strength = 0
      end
    end
    @yaku
  end


  private

  # 数字がいくつ重複しているか
  def same_number_counts
    same_numbers = @numbers.group_by {|r| r}.values
    same_numbers.map(&:size).sort.reverse
  end

  # 数が連続してるか
  def straight?
    straight_numbers = @numbers.sort
    if straight_numbers[1] == straight_numbers[0] + 1 && straight_numbers[2] == straight_numbers[0] + 2 && straight_numbers[3] == straight_numbers[0] + 3 && straight_numbers[4] == straight_numbers[0] + 4
      true
    elsif straight_numbers == [1, 10, 11, 12, 13]
      true
    else
      false
    end
  end

  # 同じスートが１組以上あるか
  def flush?
    @suits.uniq.size == 1
  end
end
