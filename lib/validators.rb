class Validators
  class << self
    def email
      /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    end

    def name
      /\A([a-zA-Z]){2,} (([a-zA-Z]){2,}|([a-zA-Z]){2,} ([a-zA-Z]){2,})\z/
    end
  end
end
