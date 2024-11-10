import 'dart:collection';

class NotificationQueue{
  int maxSize;
  ListQueue<Notification> queue=ListQueue();

  NotificationQueue({this.maxSize=50});

  void add(Notification notification){
    if(queue.length>=maxSize){
      queue.removeFirst();
    }
    queue.add(notification);
  }

  factory NotificationQueue.fromJson(Map<String,dynamic> json){
    NotificationQueue q=NotificationQueue(
      maxSize: json["maxSize"],
    );
    final notifications=json["items"] as List<dynamic>;
    for (var notification in notifications){
      q.add(Notification.fromJson(notification));
    }
    return q;
  }
}

class Notification {
  
}