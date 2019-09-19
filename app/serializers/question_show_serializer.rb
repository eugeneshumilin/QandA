class QuestionShowSerializer < QuestionSerializer
  has_many :comments
  has_many :files, serializer: FileSerializer
  has_many :links
end
