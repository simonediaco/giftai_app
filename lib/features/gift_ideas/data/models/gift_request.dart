class GiftGenerationRequest {
  final String? name;
  final String? age;
  final String? gender;
  final String? relation;
  final List<String>? interests;
  final String? category;
  final String? budget;
  
  GiftGenerationRequest({
    this.name,
    this.age,
    this.gender,
    this.relation,
    this.interests,
    this.category,
    this.budget,
  });
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (name != null) data['name'] = name;
    if (age != null) data['age'] = age;
    if (gender != null) data['gender'] = gender;
    if (relation != null) data['relation'] = relation;
    if (interests != null) data['interests'] = interests;
    if (category != null) data['category'] = category;
    if (budget != null) data['budget'] = budget;
    
    return data;
  }
}