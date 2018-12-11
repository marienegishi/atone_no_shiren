class HomeController < ApplicationController

  def new
    @card_form = CardForm.new
  end



  def judge
    hands = params[:card_form][:hands]
    @card_form = CardForm.new(hands)

    if @card_form.valid?
      flash[:hands] = @card_form.judge
    else
      flash[:hands] = @card_form.error_messages
    end
    redirect_to new_url
  end
end
