module SnellMail
  class MessageSubjects
    def initialize(subjects)
      @subjects = subjects
    end

    def construct
      if @subjects.count > 1
        join_many_subjects
      else
        @subjects[0] + ' was '
      end
    end

    private

      def join_many_subjects
        @subjects.map do |subject|
          if subject == @subjects.last
            last_of_many_subjects
          elsif @subjects.count == 2
            first_of_two_subjects
          else
            subject + ", "
          end
        end.join
      end

      def last_of_many_subjects
        "and #{@subjects.last} were "
      end

      def first_of_two_subjects
        "#{@subjects.first} "
      end
  end
end
