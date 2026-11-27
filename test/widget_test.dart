import 'dart:convert';

import 'package:cv_flutter_michee/data/api_service.dart';
import 'package:cv_flutter_michee/screens/home_screen.dart';
import 'package:cv_flutter_michee/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  testWidgets('login stays on the form when the API rejects credentials', (
    tester,
  ) async {
    final api = ApiService(
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({
            'success': false,
            'message': 'Email ou mot de passe incorrect',
          }),
          401,
        ),
      ),
      baseUrl: 'http://example.test/api',
    );

    await tester.pumpWidget(MaterialApp(home: LoginScreen(api: api)));
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'person@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'wrongpass');
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();

    expect(find.text('Bienvenue !'), findsOneWidget);
    expect(find.text('Mon Curriculum Vitae'), findsNothing);
    expect(find.text('Email ou mot de passe incorrect'), findsOneWidget);
    api.close();
  });

  testWidgets('login password can be revealed from its visibility button', (
    tester,
  ) async {
    final api = ApiService(
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({'success': false, 'message': 'Connexion refusée'}),
          401,
        ),
      ),
      baseUrl: 'http://example.test/api',
    );

    await tester.pumpWidget(MaterialApp(home: LoginScreen(api: api)));

    expect(
      tester.widget<EditableText>(find.byType(EditableText).last).obscureText,
      isTrue,
    );
    await tester.tap(find.byTooltip('Afficher le mot de passe'));
    await tester.pumpAndSettle();
    expect(
      tester.widget<EditableText>(find.byType(EditableText).last).obscureText,
      isFalse,
    );

    api.close();
  });

  testWidgets('successful API login opens the CV', (tester) async {
    final api = ApiService(
      client: MockClient((request) async {
        if (request.url.path == '/api/accounts/login') {
          return http.Response(
            jsonEncode({'success': true, 'data': <String, dynamic>{}}),
            200,
          );
        }
        if (request.url.path == '/api/famille-membres') {
          return http.Response(
            jsonEncode({'success': true, 'data': <dynamic>[]}),
            200,
          );
        }
        throw StateError('Unexpected API request: ${request.url}');
      }),
      baseUrl: 'http://example.test/api',
    );

    await tester.pumpWidget(MaterialApp(home: LoginScreen(api: api)));
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'person@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'secret123');
    await tester.tap(find.text('Se connecter'));
    await tester.pumpAndSettle();

    expect(find.text('Mon curriculum vitae'), findsOneWidget);
    api.close();
  });

  testWidgets('family and contacts use the shared app bar', (tester) async {
    final api = ApiService(
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({'success': true, 'data': <dynamic>[]}),
          200,
        ),
      ),
      baseUrl: 'http://example.test/api',
    );

    await tester.pumpWidget(MaterialApp(home: HomeScreen(api: api)));
    await tester.tap(find.text('Famille'));
    await tester.pumpAndSettle();

    expect(find.text('Ma famille'), findsOneWidget);
    expect(find.text('Ajouter'), findsOneWidget);

    await tester.tap(find.text('Contacts'));
    await tester.pumpAndSettle();

    expect(find.text('Mes coordonnées'), findsOneWidget);
    api.close();
  });

  testWidgets('CV layout adapts to a phone width', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final api = ApiService(
      client: MockClient(
        (_) async => http.Response(
          jsonEncode({'success': true, 'data': <dynamic>[]}),
          200,
        ),
      ),
      baseUrl: 'http://example.test/api',
    );

    await tester.pumpWidget(MaterialApp(home: HomeScreen(api: api)));
    await tester.pumpAndSettle();

    expect(find.text('MICHEE KADIMA WAZEKA'), findsOneWidget);
    expect(find.text('COMPÉTENCES ET EXPERTISE'), findsOneWidget);
    expect(tester.takeException(), isNull);
    api.close();
  });
}
