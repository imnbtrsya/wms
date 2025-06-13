import 'package:wms/model/rating_model.dart';

class RatingController {
  List<Foreman> getForemen() {
    return [
      Foreman(name: 'Ahmad bin Ali', rating: 4.2, jobs: 5, image: 'assets/user.jpg', viewed: true),
      Foreman(name: 'John Doe', rating: 3.5, jobs: 5, image: 'assets/user.jpg', viewed: false),
      Foreman(name: 'Sarah', rating: 3.5, jobs: 5, image: 'assets/user.jpg', viewed: false),
      Foreman(name: 'Puteri', rating: 4.6, jobs: 5, image: 'assets/user.jpg', viewed: false),
    ];
  }
}
