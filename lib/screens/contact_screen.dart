import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  Widget _contactCard({
    required IconData icon,
    required String title,
    required String value,
    required double width,
  }) {
    return SizedBox(
      width: width,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 46,
                width: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EDFA),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: const Color(0xFF4054A3), size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Color(0xFF6D758A),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    SelectionArea(
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Color(0xFF252D43),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 700;
        final horizontalPadding = wide ? 28.0 : 18.0;
        final contentWidth = (constraints.maxWidth - horizontalPadding * 2)
            .clamp(0.0, 900.0);
        final cardWidth = wide ? (contentWidth - 16) / 2 : contentWidth;

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 24,
          ),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(wide ? 26 : 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(color: const Color(0xFFE7EAF1)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: 52,
                          width: 52,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE9EDFA),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(
                            Icons.waving_hand_outlined,
                            color: Color(0xFF4054A3),
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Restons en contact',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: const Color(0xFF252D43),
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Retrouvez ici mes coordonnées.',
                                style: TextStyle(
                                  color: Color(0xFF6D758A),
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _contactCard(
                        icon: Icons.mail_outline,
                        title: 'Adresse e-mail',
                        value: 'micheek845@gmail.com',
                        width: cardWidth,
                      ),
                      _contactCard(
                        icon: Icons.phone_outlined,
                        title: 'Téléphone 1',
                        value: '+243 992 063 754',
                        width: cardWidth,
                      ),
                      _contactCard(
                        icon: Icons.phone_android_outlined,
                        title: 'Téléphone 2',
                        value: '+243 840 549 526',
                        width: cardWidth,
                      ),
                      _contactCard(
                        icon: Icons.location_on_outlined,
                        title: 'Adresse',
                        value: 'Commune de Goma, quartier Himbi',
                        width: cardWidth,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
