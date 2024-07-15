import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constant/routes.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/view/register_view.dart';
import 'package:mynotes/view/login_view.dart';
import 'package:mynotes/view/verify_email.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: const HomePage(),
      routes: {
        loginRoutes: (context) => const LoginView() ,
        regRoutes: (context) => const RegisterView(),
        notesRoutes: (context) => const NotesView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
@override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
            builder: (context, snapshot) {
              switch(snapshot.connectionState) {
                case ConnectionState.done:
                  final user = FirebaseAuth.instance.currentUser;
                  if(user != null){
                    if(user.emailVerified){
                      return const NotesView();
                    } else{
                    return const VerifyEmailView();
                  } 
                } else{
                  return const LoginView();
                }
                // ignore: dead_code
                return const Text('Done');
             default:
              return const CircularProgressIndicator();
           }
      },
    );
  }
}

enum MenuAction{logout}

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                final shouldlogout = await showLogOutDialog(context);

                    if (shouldlogout) {
                      await FirebaseAuth.instance.signOut();
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushNamedAndRemoveUntil(
                        loginRoutes, (_) => false,
                      );
                    }
                  }
                },
              itemBuilder:(context) {
                return const [
                  PopupMenuItem<MenuAction>(
                    value: MenuAction.logout,
                    child: Text('Log out'),
                  ),
                ];
              },
            )
          ],
        ),
      body: const Text('Hello World')
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context){
  return showDialog<bool>(
  context: context, 
  builder: (context) {
    return AlertDialog(
      title: const Text('Sign Out'),
      content: const Text('Are you sure you want to sign out?'),
      actions: [
        TextButton(
          onPressed: (){
          Navigator.of(context).pop('false');
        }, 
        child: const Text('Cancel') ),
        TextButton(
          onPressed: (){
          Navigator.of(context).pop('false');
        }, 
        child: const Text('Sign Out')),
        ],
      );
    },
  ).then((value) => value ?? false,);
}