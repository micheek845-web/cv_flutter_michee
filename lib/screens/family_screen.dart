import 'package:flutter/material.dart';

import '../data/api_service.dart';
import '../data/family_member.dart';

class FamilyScreen extends StatefulWidget {
  const FamilyScreen({super.key, required this.api});

  final ApiService api;

  @override
  State<FamilyScreen> createState() => _FamilyScreenState();
}

class _FamilyScreenState extends State<FamilyScreen> {
  List<FamilyMember> _members = [];
  bool _isLoading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadMembers();
  }

  Future<void> _loadMembers() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    try {
      final members = await widget.api.getFamilyMembers();
      if (mounted) setState(() => _members = members);
    } on Exception catch (error) {
      if (mounted) {
        setState(
          () => _loadError = error is ApiException
              ? error.message
              : 'Impossible de charger les membres. Vérifiez le serveur et le réseau.',
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showMemberForm({FamilyMember? member}) async {
    final values = await showDialog<Map<String, String>>(
      context: context,
      builder: (_) => FamilyMemberFormDialog(member: member),
    );
    if (values == null || !mounted) return;

    try {
      if (member == null) {
        await widget.api.createFamilyMember(values);
      } else {
        await widget.api.updateFamilyMember(member.id, values);
      }
      await _loadMembers();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              member == null ? 'Membre ajouté.' : 'Membre modifié.',
            ),
          ),
        );
      }
    } on Exception catch (error) {
      _showError(error);
    }
  }

  Future<void> _deleteMember(FamilyMember member) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer ce membre ?'),
        content: Text('Cette action supprimera ${member.fullName}.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await widget.api.deleteFamilyMember(member.id);
      await _loadMembers();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Membre supprimé.')));
      }
    } on Exception catch (error) {
      _showError(error);
    }
  }

  void _showError(Exception error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          error is ApiException
              ? error.message
              : 'Opération impossible. Vérifiez le serveur et le réseau.',
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cloud_off, size: 48, color: Colors.indigo),
              const SizedBox(height: 12),
              Text(_loadError!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: _loadMembers,
                icon: const Icon(Icons.refresh),
                label: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      );
    }
    if (_members.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9EDFA),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: const Icon(
                  Icons.people_outline,
                  size: 34,
                  color: Color(0xFF4054A3),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Votre famille apparaîtra ici',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF252D43),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ajoutez un membre pour commencer votre liste.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF6D758A)),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadMembers,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _members.length,
        itemBuilder: (context, index) {
          final member = _members[index];
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: const Color(0xFFE9EDFA),
                    backgroundImage: member.imageUrl == null
                        ? null
                        : NetworkImage(member.imageUrl!),
                    child: member.imageUrl == null
                        ? const Icon(
                            Icons.person_outline,
                            color: Color(0xFF4054A3),
                          )
                        : null,
                  ),
                  title: Text(
                    member.fullName,
                    style: const TextStyle(
                      color: Color(0xFF252D43),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text(
                      '${member.parente}  ·  Né(e) le ${member.dateNaissance} à ${member.lieuNaissance}',
                      style: const TextStyle(
                        color: Color(0xFF6D758A),
                        height: 1.35,
                      ),
                    ),
                  ),
                  trailing: PopupMenuButton<String>(
                    tooltip: 'Actions sur ${member.fullName}',
                    onSelected: (action) {
                      if (action == 'edit') _showMemberForm(member: member);
                      if (action == 'delete') _deleteMember(member);
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit_outlined),
                          title: Text('Modifier'),
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete_outline),
                          title: Text('Supprimer'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Membres de la famille',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: const Color(0xFF252D43),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Gérez les informations de vos proches.',
                        style: TextStyle(
                          color: Color(0xFF6D758A),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton.filledTonal(
                  tooltip: 'Actualiser',
                  onPressed: _loadMembers,
                  icon: const Icon(Icons.refresh),
                ),
                const SizedBox(width: 8),
                FilledButton.tonalIcon(
                  onPressed: () => _showMemberForm(),
                  icon: const Icon(Icons.person_add_alt_1, size: 18),
                  label: const Text('Ajouter'),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE7EAF1)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 8),
              child: _buildBody(),
            ),
          ),
        ],
      ),
    );
  }
}

class FamilyMemberFormDialog extends StatefulWidget {
  const FamilyMemberFormDialog({super.key, this.member});

  final FamilyMember? member;

  @override
  State<FamilyMemberFormDialog> createState() => _FamilyMemberFormDialogState();
}

class _FamilyMemberFormDialogState extends State<FamilyMemberFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nomController;
  late final TextEditingController _postnomController;
  late final TextEditingController _prenomController;
  late final TextEditingController _lieuController;
  late final TextEditingController _parenteController;
  DateTime? _dateNaissance;

  @override
  void initState() {
    super.initState();
    final member = widget.member;
    _nomController = TextEditingController(text: member?.nom ?? '');
    _postnomController = TextEditingController(text: member?.postnom ?? '');
    _prenomController = TextEditingController(text: member?.prenom ?? '');
    _lieuController = TextEditingController(text: member?.lieuNaissance ?? '');
    _parenteController = TextEditingController(text: member?.parente ?? '');
    _dateNaissance = member == null
        ? null
        : DateTime.tryParse(member.dateNaissance);
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _dateNaissance ?? DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (selectedDate != null) setState(() => _dateNaissance = selectedDate);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_dateNaissance == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez choisir une date de naissance.'),
        ),
      );
      return;
    }
    Navigator.of(context).pop({
      'nom': _nomController.text.trim(),
      'postnom': _postnomController.text.trim(),
      'prenom': _prenomController.text.trim(),
      'lieu_naissance': _lieuController.text.trim(),
      'date_naissance': _dateNaissance!.toIso8601String().substring(0, 10),
      'parente': _parenteController.text.trim(),
    });
  }

  @override
  void dispose() {
    _nomController.dispose();
    _postnomController.dispose();
    _prenomController.dispose();
    _lieuController.dispose();
    _parenteController.dispose();
    super.dispose();
  }

  Widget _textField(
    TextEditingController controller,
    String label, {
    int maxLength = 50,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          counterText: '',
        ),
        validator: (value) => value == null || value.trim().isEmpty
            ? 'Ce champ est obligatoire.'
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.member != null;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(isEditing ? 'Modifier le membre' : 'Ajouter un membre'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _textField(_nomController, 'Nom'),
              _textField(_postnomController, 'Postnom'),
              _textField(_prenomController, 'Prénom'),
              _textField(_lieuController, 'Lieu de naissance', maxLength: 100),
              _textField(_parenteController, 'Parenté'),
              FormField<DateTime>(
                initialValue: _dateNaissance,
                validator: (_) =>
                    _dateNaissance == null ? 'Date obligatoire.' : null,
                builder: (field) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _selectDate,
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        _dateNaissance == null
                            ? 'Date de naissance'
                            : _dateNaissance!.toIso8601String().substring(
                                0,
                                10,
                              ),
                      ),
                    ),
                    if (field.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 4),
                        child: Text(
                          field.errorText!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 12,
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
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(isEditing ? 'Enregistrer' : 'Ajouter'),
        ),
      ],
    );
  }
}
