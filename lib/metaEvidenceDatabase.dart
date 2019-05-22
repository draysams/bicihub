class MetaEvidence {
  String question;
  String id;
  String choiceId;

  MetaEvidence(this.id, this.choiceId, this.question);

  MetaEvidence.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        choiceId = json['choice_id'],
        question = json['question'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'choice_id': choiceId, 'question': question};
}