import 'package:flutter/material.dart';

class CvResumeScreen extends StatelessWidget {
  const CvResumeScreen({super.key});

  static const _paper = Color(0xFFE7D1C4);
  static const _sidebarColor = Color(0xFF919493);
  static const _ink = Color(0xFF25282B);

  Widget _portrait({required double width, required double height}) {
    return SizedBox(
      width: width,
      height: height,
      child: Image.asset(
        'assets/images/profil.png',
        fit: BoxFit.cover,
        alignment: const Alignment(0, 0.48),
      ),
    );
  }

  Widget _identity({required bool compact}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'MICHEE KADIMA WAZEKA',
          style: TextStyle(
            color: _ink,
            fontSize: compact ? 21 : 34,
            height: 1.05,
            fontWeight: FontWeight.w400,
            letterSpacing: compact ? 0 : 0.4,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'ÉTUDIANT EN INFORMATIQUE',
          style: TextStyle(
            color: _ink.withValues(alpha: 0.72),
            fontSize: compact ? 11 : 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.7,
          ),
        ),
      ],
    );
  }

  Widget _contactLine(IconData icon, String value, {bool compact = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: compact ? 15 : 17, color: _ink),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: _ink.withValues(alpha: 0.82),
                fontSize: compact ? 11 : 13,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.45,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 12),
            child: Divider(height: 1, color: Color(0x66FFFFFF)),
          ),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                item,
                style: const TextStyle(
                  color: Color(0xFFF7F7F6),
                  fontSize: 13,
                  height: 1.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebar({required bool includePortrait}) {
    return Container(
      color: _sidebarColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (includePortrait) _portrait(width: double.infinity, height: 230),
          _sidebarSection('COMPÉTENCES ET EXPERTISE', const [
            'Microsoft Word',
            'Microsoft Excel',
            'Microsoft PowerPoint',
            'Développement d’applications web',
          ]),
          _sidebarSection('LANGUES', const [
            'Français',
            'Anglais',
            'Swahili',
            'Lingala',
            'Tshiluba',
          ]),
          _sidebarSection('CENTRES D’INTÉRÊT', const [
            'Entrepreneuriat',
            'Nouvelles technologies',
            'Lecture, sport, voyages et musique',
          ]),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _cvSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 26, 30, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: _ink,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.55,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10, bottom: 16),
            child: Divider(height: 1, color: Color(0x663B3531)),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _cvEntry(String title, String subtitle, {String? detail}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: _ink,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: _ink.withValues(alpha: 0.86),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (detail != null) ...[
            const SizedBox(height: 4),
            Text(
              detail,
              style: TextStyle(
                color: _ink.withValues(alpha: 0.75),
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _mainContent({required bool compact, bool includeHeader = true}) {
    return Container(
      color: _paper,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (includeHeader)
            Padding(
              padding: EdgeInsets.fromLTRB(
                compact ? 18 : 34,
                compact ? 22 : 36,
                compact ? 18 : 34,
                12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _identity(compact: compact),
                  const SizedBox(height: 22),
                  _contactLine(
                    Icons.location_on_outlined,
                    'Commune de Goma, quartier Himbi',
                    compact: compact,
                  ),
                  _contactLine(
                    Icons.phone_outlined,
                    '+243 992 063 754  ·  +243 840 549 526',
                    compact: compact,
                  ),
                  _contactLine(
                    Icons.mail_outline,
                    'micheek845@gmail.com',
                    compact: compact,
                  ),
                ],
              ),
            ),
          _cvSection('Formation', [
            _cvEntry(
              'L3 — Informatique',
              'Institut Supérieur d’Informatique et de Gestion (ISIG-GOMA)',
              detail: 'Domaine : Informatique',
            ),
          ]),
          _cvSection('Expériences professionnelles', [
            _cvEntry('Secrétariat', 'Mairie de Goma'),
            _cvEntry('DPS', 'Travaux d’encodage'),
          ]),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _mobileHeader(double availableWidth) {
    final portraitWidth = availableWidth < 360 ? 82.0 : 104.0;
    return Container(
      color: _paper,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRect(child: _portrait(width: portraitWidth, height: 130)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _identity(compact: true),
                const SizedBox(height: 14),
                _contactLine(
                  Icons.location_on_outlined,
                  'Commune de Goma, quartier Himbi',
                  compact: true,
                ),
                _contactLine(
                  Icons.phone_outlined,
                  '+243 992 063 754  ·  +243 840 549 526',
                  compact: true,
                ),
                _contactLine(
                  Icons.mail_outline,
                  'micheek845@gmail.com',
                  compact: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 700;
        return SingleChildScrollView(
          padding: EdgeInsets.all(wide ? 24 : 12),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: ClipRect(
                child: wide
                    ? IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SizedBox(
                              width: 280,
                              child: _sidebar(includePortrait: true),
                            ),
                            Expanded(child: _mainContent(compact: false)),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _mobileHeader(constraints.maxWidth),
                          _sidebar(includePortrait: false),
                          _mainContent(compact: true, includeHeader: false),
                        ],
                      ),
              ),
            ),
          ),
        );
      },
    );
  }
}
