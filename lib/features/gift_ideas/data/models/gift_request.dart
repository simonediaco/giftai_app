class GiftGenerationRequest {
  final String? name;
  final String? age;
  final String? gender;
  final String? relation;
  final List<String>? interests;
  final String? category;
  final int? min_price;
  final int? max_price;
  
  GiftGenerationRequest({
    this.name,
    this.age,
    this.gender,
    this.relation,
    this.interests,
    this.category,
    this.min_price,
    this.max_price,
  });
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    
    if (name != null) data['name'] = name;
    if (age != null) data['age'] = age;
    if (gender != null) data['gender'] = gender;
    if (relation != null) data['relation'] = relation;
    if (interests != null) data['interests'] = interests;
    if (category != null) data['category'] = category;
    if (min_price != null) data['min_price'] = min_price;
    if (max_price != null) data['max_price'] = max_price;
    
    return data;
  }
}