//TODOINIT: adjust this import to find your project's injection file
import 'package:{{project_name}}/injection/injection.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:neon_chat/neon_chat.dart';

@module
abstract class NEONChatInjectableModule {
  //TODOINIT: fill the firebase keys with custom ones if needed.
  //TODOINIT: adjust firebaseKEys environment to the environment used by getIt
  @lazySingleton
  FirebaseKeys get firebaseKeys => const FirebaseKeys();

  @LazySingleton(as: ConversationRepository)
  ConversationRepositoryImpl get conversationRepository =>
      ConversationRepositoryImpl(
        firestore: getIt<FirebaseFirestore>(),
        firebaseAuth: getIt<FirebaseAuth>(),
        firebaseKeys: firebaseKeys,
      );

  @LazySingleton(as: ConversationsRepository)
  ConversationsRepositoryImpl get conversationsRepository =>
      ConversationsRepositoryImpl(
        firestore: getIt<FirebaseFirestore>(),
        firebaseAuth: getIt<FirebaseAuth>(),
        firebaseKeys: firebaseKeys,
      );

  @LazySingleton(as: FileUploadRepository)
  FileUploadRepositoryImpl get fileUploadRepository =>
      FileUploadRepositoryImpl(remoteDataSource: getIt<RemoteDataSource>());

  @LazySingleton(as: UploadManagerRepository)
  UploadManagerRepositoryImpl get uploadManagerRepository =>
      UploadManagerRepositoryImpl(fileUploadRepository: fileUploadRepository);

  @LazySingleton(as: FirebaseUserProfileRepository)
  FirebaseUserProfileRepositoryImpl get firebaseUserProfileRepository =>
      FirebaseUserProfileRepositoryImpl(
        firestore: getIt<FirebaseFirestore>(),
        firebaseKeys: firebaseKeys,
      );

  @lazySingleton
  HideMessageUC get hideMessageUC => HideMessageUC(conversationRepository);

  @lazySingleton
  DeleteMessageUC get deleteMessageUC =>
      DeleteMessageUC(conversationRepository);

  @lazySingleton
  MarkMessageAsSeenUC get markAsSeenUC =>
      MarkMessageAsSeenUC(conversationRepository);

  @lazySingleton
  SendPlatformFileMessageUC get sendPlatformFileMessageUC =>
      SendPlatformFileMessageUC(
          conversationRepository: conversationRepository,
          uploadManagerRepository: uploadManagerRepository);

  @lazySingleton
  SendFileMessageUC get sendFileMessageUC => SendFileMessageUC(
      conversationRepository: conversationRepository,
      uploadManagerRepository: uploadManagerRepository);

  @lazySingleton
  SendTextMessageUC get sendTextMessageUC =>
      SendTextMessageUC(conversationRepository);

  @lazySingleton
  InitializeConversationStreamUC get initializeConversationStreamUC =>
      InitializeConversationStreamUC(
          conversationRepository: conversationRepository,
          conversationsRepository: conversationsRepository,
          firebaseUserProfileRepository: firebaseUserProfileRepository);

  @lazySingleton
  InitializeConversationItemStreamUC get initializeConversationItemStreamUC =>
      InitializeConversationItemStreamUC(
          conversationRepository: conversationRepository,
          conversationsRepository: conversationsRepository,
          userProfileRepository: firebaseUserProfileRepository);

  @lazySingleton
  InitializeConversationsStreamUC get initializeConversationsStreamUC =>
      InitializeConversationsStreamUC(conversationsRepository);

  @lazySingleton
  HideConversationUC get hideConversationUC =>
      HideConversationUC(conversationsRepository);

  @lazySingleton
  ChatBloc get chatBloc => ChatBloc(
      firebaseAuth: getIt<FirebaseAuth>(),
      hideMessageUC: hideMessageUC,
      deleteMessageUC: deleteMessageUC,
      markAsSeenUC: markAsSeenUC,
      sendPlatformFileMessageUC: sendPlatformFileMessageUC,
      sendFileMessageUC: sendFileMessageUC,
      sendTextMessageUC: sendTextMessageUC,
      initStreamUC: initializeConversationStreamUC);

  @lazySingleton
  ChatSearchBloc get chatSearchBloc => ChatSearchBloc();

  @lazySingleton
  CurrentConversationCubit get currentConversationCubit =>
      CurrentConversationCubit();

  @lazySingleton
  ConversationsBloc get conversationsBloc => ConversationsBloc(
      initializeConversationsStreamUC: initializeConversationsStreamUC,
      initializeConversationItemStreamUC: initializeConversationItemStreamUC,
      hideConversationUC: hideConversationUC);

  @lazySingleton
  ConversationsSearchBloc get conversationsSearchBloc =>
      ConversationsSearchBloc();
}
