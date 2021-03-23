class TaskModel {
  String  title= "";
  String  location = "";
  String image = "";

  TaskModel();

  TaskModel.fromData(this.title, this.location, this.image);
}