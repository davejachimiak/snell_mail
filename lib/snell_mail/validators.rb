module SnellMail
  class Validators
    def self.email
      /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    end
  end
end