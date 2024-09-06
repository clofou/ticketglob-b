import 'package:flutter/material.dart';
import 'package:ticketglob/Widgets/user_data_table.dart';
import 'package:ticketglob/models/users_data.dart';
import 'package:ticketglob/services/auth_service.dart';
import 'package:ticketglob/services/db_service.dart';
import 'package:ticketglob/utils.dart';

enum Categorie { technique, theorique }

enum Role { apprenant, formateur, admin }

Categorie categorieView = Categorie.theorique;
Role roleView = Role.formateur;

class AccountSection extends StatefulWidget {
  final String searchQuery;
  final Function(String) onSearch;
  const AccountSection(
      {super.key, required this.onSearch, required this.searchQuery});

  @override
  State<AccountSection> createState() => _AccountSectionState();
}

class _AccountSectionState extends State<AccountSection> {
  AddAccountModal() {
    TextEditingController email = TextEditingController();
    TextEditingController nomComplet = TextEditingController();
    TextEditingController password = TextEditingController();
    TextEditingController telephone = TextEditingController();
    TextEditingController confirmPassword = TextEditingController();
    bool obscure = true;
    final formKey = GlobalKey<FormState>();

    return StatefulBuilder(builder:
        (BuildContext context, void Function(void Function()) setState) {
      return AlertDialog(
        title: const Text(
          "Creation de Compte",
          style: AppTextStyles.headline2,
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // Nom Complet
                  TextFormField(
                    style: const TextStyle(color: AppColors.primarySwatch),
                    controller: nomComplet,
                    validator: (value) =>
                        value!.trim() != "" && value.length > 3
                            ? null
                            : "Le nom doit avoir plus de 3 caractères",
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: AppColors.primarySwatch),
                        prefixIcon: Icon(AppIcons.profil),
                        label: Text("Nom Complet"),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: AppColors.primarySwatch, width: 2)),
                        border: OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // Email
                  TextFormField(
                    controller: email,
                    validator: (value) => AppFunction.isValidEmail(email.text)
                        ? null
                        : "L'email est invalide",
                    decoration: InputDecoration(
                        prefixIcon: const Icon(AppIcons.mail),
                        label: const Text("Email"),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    AppColors.primarySwatch.withOpacity(0.4))),
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // Mot de Passe
                  TextFormField(
                    controller: password,
                    obscureText: obscure,
                    validator: (value) => value!.length >= 6
                        ? null
                        : "Le mot de passe doit comporter plus de 6 caractères",
                    decoration: InputDecoration(
                        prefixIcon: const Icon(AppIcons.password),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  obscure = !obscure;
                                },
                              );
                            },
                            icon: obscure
                                ? const Icon(AppIcons.visible)
                                : const Icon(AppIcons.visibilityoff)),
                        label: const Text("Mot de passe"),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    AppColors.primarySwatch.withOpacity(0.4))),
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // confirmer
                  TextFormField(
                    controller: confirmPassword,
                    validator: (value) => value == password.text
                        ? null
                        : "Les mot de passe ne correspondent pas",
                    decoration: InputDecoration(
                        prefixIcon: const Icon(AppIcons.password),
                        label: const Text("Confirmer le mot de passe"),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    AppColors.primarySwatch.withOpacity(0.4))),
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // telephone
                  TextFormField(
                    controller: telephone,
                    validator: (value) =>
                        AppFunction.isValidInternationalPhoneNumber(
                                telephone.text)
                            ? null
                            : "Entrer Un numero au format international",
                    decoration: InputDecoration(
                        hintText: "+22373...",
                        hintStyle: AppTextStyles.bodyText1
                            .copyWith(color: Colors.grey),
                        prefixIcon: const Icon(AppIcons.call),
                        label: const Text("Telephone"),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    AppColors.primarySwatch.withOpacity(0.4))),
                        border: const OutlineInputBorder()),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  // Role de l'user
                  const RoleChoice()
                ],
              ),
            ),
          ),
        ),
        actions: [
          ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  try {
                    final result = await AuthService().inscription(
                        emailAddress: email.text,
                        password: password.text,
                        role: roleView.name.toUpperCase(),
                        nomComplet: nomComplet.text,
                        telephone: telephone.text);
                    print(result);
                    if (result["isOk"] as bool) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          AppGlobal.snackdemo(
                              message: "Compte Crée avec Succèes !",
                              backgroundColor: Colors.green));
                      Navigator.of(context).pop();
                      setState(() {});
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        AppGlobal.snackdemo(
                            message: "$e", backgroundColor: Colors.red));
                  }
                }
              },
              child: const Text("Creer le Compte")),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Annuler")),
        ],
      );
    });
  }

  void sortByDate(String? he) {}

  List<UserData> users = [];
  bool _isLoading = true;
  String _selectedRole = 'Tous';
  @override
  void initState() {
    super.initState();
    _fetchUsers(); // Récupère les utilisateurs à l'initialisation
  }

  // Récupère les utilisateurs via FirebaseService
  Future<void> _fetchUsers() async {
    DbService firebaseService = DbService();
    List<UserData> fetchedUsers =
        await firebaseService.fetchUsersFromFirestore();

    setState(() {
      users = fetchedUsers;
      _isLoading = false;
    });
  }

  // Filtrer les utilisateurs selon le rôle
  List<UserData> _filterUsersByRole() {
    if (_selectedRole == 'Tous') {
      return users;
    } else {
      return users.where((user) => user.role == _selectedRole).toList();
    }
  }

  List<UserData> _filterUsersByRoleAndSearch(String query) {
    List<UserData> filteredUsers = _filterUsersByRole();
    if (query.isNotEmpty) {
      filteredUsers = filteredUsers
          .where((user) =>
              user.email.toLowerCase().contains(query.toLowerCase()) ||
              user.nomComplet.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    return filteredUsers;
  }

  // Couleur en fonction du rôle
  Color _getRoleColor(String role) {
    switch (role) {
      case 'ADMIN':
        return Colors.red.shade100;
      case 'FORMATEUR':
        return Colors.green.shade100;
      case 'APPRENANT':
        return Colors.blue.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        HeadSection(context),
        const SizedBox(
          height: 10,
        ),
        FilterSection(),
        const SizedBox(
          height: 15,
        ),
        tableViewSection(),
      ],
    );
  }

  Widget HeadSection(BuildContext context) {
    Widget myButton = ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          backgroundColor: AppColors.primarySwatch),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AddAccountModal(),
        );
      },
      label: const Text(
        "Creer un nouveau compte",
        style: TextStyle(color: Colors.white),
      ),
      icon: const Icon(
        AppIcons.add,
        color: Colors.white,
      ),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Comptes",
            style: AppTextStyles.headline2,
          ),
          myButton,
        ],
      ),
    );
  }

  Widget FilterSection() {
    Widget leftSection = Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButton<String>(
        focusColor: AppColors.primarySwatch,
        style: Theme.of(context).textTheme.bodyMedium,
        value: _selectedRole,
        items: <String>['Tous', 'FORMATEUR', 'ADMIN', 'APPRENANT']
            .map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              'Rôle : $value',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedRole = newValue!;
          });
        },
      ),
    );

    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: const [
            BoxShadow(
                offset: Offset(0, 2), blurRadius: 10, color: Color(0xFF979797))
          ]),
      height: 55,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          leftSection,
          IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.refresh))
        ],
      ),
    );
  }

  Widget tableViewSection() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
                child: PaginatedDataTable(
              header: const Text(
                'Comptes Firebase',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: AppColors.primarySwatch, // Couleur personnalisée
                ),
              ),
              columns: const [
                DataColumn(
                  label: Text(
                    'Date Création',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primarySwatch, // Couleur personnalisée
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'UID',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primarySwatch,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Email',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primarySwatch,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Nom Complet',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primarySwatch,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Dernière Connexion',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primarySwatch,
                    ),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Rôle',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primarySwatch,
                    ),
                  ),
                ),
              ],
              source: UserDataSource(
                  users: _filterUsersByRoleAndSearch(widget.searchQuery),
                  getRoleColor: _getRoleColor),
              rowsPerPage: 5,
              // Styliser les bordures de la table
              columnSpacing: 15,
              headingRowHeight: 60, // Hauteur de l'en-tête
            )),
          );
  }
}

class CategorieChoice extends StatefulWidget {
  const CategorieChoice({super.key});

  @override
  State<CategorieChoice> createState() => _CategorieChoiceState();
}

class _CategorieChoiceState extends State<CategorieChoice> {
  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Categorie>(
      style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white, shape: const BeveledRectangleBorder()),
      segments: const <ButtonSegment<Categorie>>[
        ButtonSegment<Categorie>(
            value: Categorie.theorique,
            label: Text('Theorique'),
            icon: Icon(AppIcons.theorique)),
        ButtonSegment<Categorie>(
            value: Categorie.technique,
            label: Text('Technique'),
            icon: Icon(AppIcons.pratique)),
      ],
      selected: <Categorie>{categorieView},
      onSelectionChanged: (Set<Categorie> newSelection) {
        setState(() {
          // By default there is only a single segment that can be
          // selected at one time, so its value is always the first
          // item in the selected set.
          categorieView = newSelection.first;
        });
      },
    );
  }
}

class RoleChoice extends StatefulWidget {
  const RoleChoice({super.key});

  @override
  State<RoleChoice> createState() => _RoleChoiceState();
}

class _RoleChoiceState extends State<RoleChoice> {
  @override
  Widget build(BuildContext context) {
    return SegmentedButton<Role>(
      segments: const <ButtonSegment<Role>>[
        ButtonSegment<Role>(
            value: Role.apprenant,
            label: Text('Apprenant'),
            icon: Icon(AppIcons.profil)),
        ButtonSegment<Role>(
            value: Role.formateur,
            label: Text('Formateur'),
            icon: Icon(AppIcons.teacher)),
        ButtonSegment<Role>(
            value: Role.admin,
            label: Text('Admin'),
            icon: Icon(AppIcons.admin)),
      ],
      selected: <Role>{roleView},
      onSelectionChanged: (Set<Role> newSelection) {
        setState(() {
          // By default there is only a single segment that can be
          // selected at one time, so its value is always the first
          // item in the selected set.
          roleView = newSelection.first;
        });
      },
    );
  }
}
