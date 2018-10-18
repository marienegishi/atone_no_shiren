class CardForm
  attr_accessor :hands
  attr_accessor :error_messages
  include ActiveModel::Model

  def initialize(hands=nil)
    @hands = hands
  end

  # 入力できる内容かバリデーションを判定する


  def valid?
    @error_messages = []
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
    # 数字とアルファベットのセット、数字が13以下
    hands.each do |hand|
      if (/(S|H|D|C)([1-9]|1[0-3])$/.match(hand)).nil?
        @error_messages << "半角英字大文字のスート（S,H,D,C）と数字（1〜13）の組み合わせでカードを指定してください。"
        return false
      end
    end
  end

  #役の配列をつくる。インデックスの大小で役の強弱を表す。（.freezeは変更不可にするやつ）
    YAKU = ["ハイカード", "ワンペア", "ツーペア", "スリー・オブ・ア・カインド", "ストレート", "フラッシュ", "フルハウス", "フォー・オブ・ア・カインド", "ストレートフラッシュ"].freeze

    #役の判断。大きい順に行う。
   def judge
      #半角空白で文字列を分割し、配列を返す。
      hands = @hands.split
      #それそれのカードから、スートの部分だけ、数字の部分だけを取り出した配列を別に作る。
      @suits = []
      @numbers = []

      hands.each do |c|
        @suits << c[0]
        @numbers << c[1..-1].to_i
      end

      def same_number_counts
        same_numbers = @numbers.group_by{|r|r}.values
        same_numbers.map(&:size).sort.reverse

       # #@numbers.group_by(&:itself).map { |k,v| [k, v.count] }.to_h.sort.reverse
        #@numbers.group_by { |r| r[0]}.map{|r|r.size}.sort.reverse
      end

      # 数が連続してる
      def straight?
        straight_numbers = @numbers.sort
        if straight_numbers[1] == straight_numbers[0]+1 && straight_numbers[2] == straight_numbers[0]+2 && straight_numbers[3] == straight_numbers[0]+3 && straight_numbers[4] == straight_numbers[0]+4
          true
        elsif straight_numbers == [1, 10, 11, 12, 13]
          true
        else
          false
        end

       # straight_numbers[1] == straight_numbers[0]+1 && straight_numbers[2] == straight_numbers[0]+2 && straight_numbers[3] == straight_numbers[0]+3 && straight_numbers[4] == straight_numbers[0]+4 || straight_numbers == [1, 10, 11, 12, 13]
        #steps = @numbers.map{|r|r-@numbers[0]}
        #steps==[0,1,2,3,4] || steps==[0,9,10,11,12]
        # sorted = @numbers.sort #.sortは順番を正す
        # steps = sorted.map { |r| r - sorted[0] }
        # #steps = sorted.map  { |k,v| [k, v.count - sorted[0]] }
        # steps == [0, 1, 2, 3, 4] || steps == [0, 9, 10, 11, 12]
      end

      # 同じスートが１組以上ある
      def flush?
        @suits.uniq.size == 1
      end

      case same_number_counts
      when [2, 1, 1, 1]
        YAKU[1]
      when [2, 2, 1]
        YAKU[2]
      when [3, 1, 1]
        YAKU[3]
      when [3, 2]
        YAKU[6]
      when [4, 1]
        YAKU[7]
      else
        case [straight?, flush?]
        when [true, false]
          YAKU[4]
        when [false, true]
          YAKU[5]
        when [true, true]
         # if @numbers == [1, 10, 11, 12, 13] #koko
            YAKU[8]
        else
          YAKU[0]
        end
      end
   end



  # def end_program
  #   exit
  # end


  # def exception
  #   puts '入力された値は無効です'
  # end

  # メニューの表示
  # loop do
  #   puts '[0]役を判定する'
  #   puts '[1]アプリを終了する'
  #   input = gets.to_i
  #
  #   case input
  #   when 0
  #     puts judge
  #   when 1
  #     end_program
  #   else
  #     exception
  #   end
  # end
   end
