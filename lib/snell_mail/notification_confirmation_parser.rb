module SnellMail
  class NotificationConfirmationParser
    def initialize(departments)
      @departments = departments
    end

    def confirmation
      if @departments.count > 1
        parse_many_departments
      else
        @departments[0] + ' was '
      end
    end

    private

      def parse_many_departments
        @departments.map do |department|
          if department == @departments.last
            last_of_many_departments
          elsif @departments.count == 2
            first_of_two_departments
          else
            department + ", "
          end
        end.join
      end

      def last_of_many_departments
        "and #{@departments.last} were "
      end

      def first_of_two_departments
        "#{@departments.first} "
      end
  end
end
