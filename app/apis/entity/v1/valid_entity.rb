
module Entity
  module V1
    class Valid_Entity < Grape::Entity
      # {"comments":[]}
      # というJSON出力になります。
      root 'error'

      expose :card, :error_message
    end
  end
end
