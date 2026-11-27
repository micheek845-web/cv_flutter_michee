import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:cv_flutter_michee/data/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

void main() {
  test(
    'login sends credentials to the API and rejects invalid credentials',
    () async {
      final client = MockClient((request) async {
        expect(request.method, 'POST');
        expect(request.url.path, '/api/accounts/login');
        expect(jsonDecode(request.body), {
          'email': 'user@example.com',
          'password': 'secret123',
        });
        return http.Response(
          jsonEncode({'success': false, 'message': 'Identifiants incorrects'}),
          401,
        );
      });
      final api = ApiService(
        client: client,
        baseUrl: 'http://example.test/api',
      );

      await expectLater(
        api.login('user@example.com', 'secret123'),
        throwsA(
          isA<ApiException>().having(
            (error) => error.message,
            'message',
            'Identifiants incorrects',
          ),
        ),
      );
      api.close();
    },
  );

  test('family list is parsed from the API response', () async {
    final client = MockClient((request) async {
      expect(request.method, 'GET');
      expect(request.url.path, '/api/famille-membres');
      return http.Response(
        jsonEncode({
          'success': true,
          'data': [
            {
              'id': 12,
              'nom': 'Kadima',
              'postnom': 'Wazeka',
              'prenom': 'Marie',
              'lieu_naissance': 'Goma',
              'date_naissance': '1975-02-14',
              'parente': 'Mère',
              'image_url': null,
            },
          ],
        }),
        200,
      );
    });
    final api = ApiService(client: client, baseUrl: 'http://example.test/api');

    final members = await api.getFamilyMembers();

    expect(members, hasLength(1));
    expect(members.single.fullName, 'Kadima Wazeka Marie');
    expect(members.single.parente, 'Mère');
    api.close();
  });

  test('family create, update and delete use the API routes', () async {
    final requests = <http.Request>[];
    final client = MockClient((request) async {
      requests.add(request);
      return http.Response(
        jsonEncode({'success': true, 'data': <String, dynamic>{}}),
        200,
      );
    });
    final api = ApiService(client: client, baseUrl: 'http://example.test/api');
    const member = {
      'nom': 'Kadima',
      'postnom': 'Wazeka',
      'prenom': 'Marie',
      'lieu_naissance': 'Goma',
      'date_naissance': '1975-02-14',
      'parente': 'Mère',
    };

    await api.createFamilyMember(member);
    await api.updateFamilyMember(12, member);
    await api.deleteFamilyMember(12);

    expect(requests.map((request) => request.method), [
      'POST',
      'PUT',
      'DELETE',
    ]);
    expect(requests.map((request) => request.url.path), [
      '/api/famille-membres',
      '/api/famille-membres/12',
      '/api/famille-membres/12',
    ]);
    expect(jsonDecode(requests.first.body), member);
    api.close();
  });
}
