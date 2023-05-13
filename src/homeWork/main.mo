import Buffer "mo:base/Buffer";
import Time "mo:base/Time";
import Result "mo:base/Result";
import Nat "mo:base/Nat";

actor class Homework() {
  type Homework = {
    title : Text;
    description : Text;
    dueDate : Time.Time;
    completed : Bool;
  };

  let homeworkDiary = Buffer.Buffer<Homework>(0);

  public shared func addHomework(homework : Homework) : async Nat {
    homeworkDiary.add(homework);
    return homeworkDiary.size();
  };

  public shared query func getHomework(id : Nat) : async Result.Result<Homework, Text> {
    let newid : Nat = id - 1;
    let todo = homeworkDiary.getOpt(newid);
    if (todo != null) {
      return #ok(homeworkDiary.get(newid));
    } else {
      return #err("task does not exist");
    };
  };

  public shared func updateHomework(id : Nat, homework : Homework) : async Result.Result<(), Text> {
    let newid : Nat = id - 1;
    let todo = homeworkDiary.getOpt(newid);
    if (todo != null) {
      let res = homeworkDiary.put(newid, homework);
      return #ok(res);
    } else {
      return #err("not implemented");
    };
  };

  public shared func markAsCompleted(id : Nat) : async Result.Result<(), Text> {
    let newid : Nat = id - 1;
    let todo = homeworkDiary.getOpt(newid);
    if (todo != null) {
      let res = homeworkDiary.get(newid);
      let newTodo : Homework = {
        title = res.title;
        description = res.description;
        dueDate = res.dueDate;
        completed = true;
      };
      let new = homeworkDiary.put(newid, newTodo);
      return #ok(new);
    } else {
      return #err("not implemented");
    };
  };

  public shared func deleteHomework(id : Nat) : async Result.Result<(), Text> {
    let newid : Nat = id - 1;
    let todo = homeworkDiary.getOpt(newid);
    if (todo != null) {
      let x = homeworkDiary.remove(newid);
      return #ok();
    } else {
      return #err("not implemented");
    };
  };

  public shared query func getAllHomework() : async [Homework] {
    let res = Buffer.toArray(homeworkDiary);
    return res;
  };

  public shared query func getPendingHomework() : async [Homework] {
    let arrayRes = Buffer.Buffer<Homework>(0);
    for (element in homeworkDiary.vals()) {
      if (not element.completed) {
        arrayRes.add(element);
      };
    };
    let res = Buffer.toArray(arrayRes);
    return res;
  };

  public shared query func searchHomework(searchTerm : Text) : async [Homework] {
    let resultado = Buffer.Buffer<Homework>(0);
    for (element in homeworkDiary.vals()) {
      if (element.title == searchTerm or element.description == searchTerm) {
        resultado.add(element);
      };
    };
    let res = Buffer.toArray(resultado);
    return res;
  };
};
