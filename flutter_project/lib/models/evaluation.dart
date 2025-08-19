class EvaluationDTO {
  final int userId;
  final int trainingId;
  final double score;

  EvaluationDTO({
    required this.userId,
    required this.trainingId,
    required this.score,
  });

  Map<String, dynamic> toJson() => {
    'userId': userId,
    'trainingId': trainingId,
    'score': score,
  };
}