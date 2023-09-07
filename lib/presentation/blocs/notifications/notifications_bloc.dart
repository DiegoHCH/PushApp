import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:push_app/firebase_options.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationsBloc() : super(const NotificationsState()) {
    
    on<NotificationStatusChanged>( _notificationStatusChanged );

    //Verificar estado de las notificaciones
    _initialStatusChack();
    //Listener para notificaciones en Foreground
    _onForegroundMessage();
  }

  static Future<void> initializeFCM() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    );
  }

  void _notificationStatusChanged( NotificationStatusChanged event, Emitter<NotificationsState> emit ) {
    emit(
      state.copyWith(
        status: event.status
      )
    );
    _getFCMToken();
  }

  void _initialStatusChack() async {
    final settings = await messaging.getNotificationSettings();
    add( NotificationStatusChanged( settings.authorizationStatus ));
  }

  void _getFCMToken() async {
    if( state.status != AuthorizationStatus.authorized ) return ;

    final token = await messaging.getToken();
    print(token);
  }

  void _handlerRemoteMessage( RemoteMessage message) {
    print('Recibí un mensaje mientras estaba en primer plano!');
    print('Datos del mensaje: ${message.data}');

    if( message.notification == null ) return;
    print('El mensaje también contenía una notificación: ${message.notification}');
  
  }

  void _onForegroundMessage() {
    FirebaseMessaging.onMessage.listen(_handlerRemoteMessage);
  }

  void requestPermission() async {

      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: true,
        provisional: false,
        sound: true,
      );

      add( NotificationStatusChanged(settings.authorizationStatus) );
  }

}
