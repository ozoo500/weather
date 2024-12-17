import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_app/constants/app_localization.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_string.dart';
import '../../controller/auth_controller.dart';
import '../../controller/crud_controller.dart';
import '../../controller/launch_method.dart';
import '../../responsive/responsive_text.dart';
import '../widgets/custom_button.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _reportTitleController = TextEditingController();
  final TextEditingController _reportDescController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    final logOut = ref.read(authServiceProvider);
    final updateUser = ref.read(authServiceProvider);
    final theme = Theme.of(context);
    final userDataAsync = ref.watch(userDataProvider);
    ref.refresh(userDataProvider);

    return Scaffold(
      appBar: AppBar(
        leading: _isEditing && screenWidth <= 600
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    _isEditing = false;
                  });
                },
              )
            : null,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: screenWidth > 600 ? 600 : screenWidth * 0.9,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                userDataAsync.when(
                  loading: () => const CircularProgressIndicator(),
                  error: (e, stack) => Text('Error: $e'),
                  data: (userData) {
                    if (userData == null) {
                      return const Text("No user data found.");
                    }

                    final userName = userData['name'] ?? 'User';
                    final userEmail =
                        userData['email'] ?? 'Email not available';
                    _nameController.text = userName;
                    _emailController.text = userEmail;

                    return Column(
                      children: [
                        if (!_isEditing) ...[
                          Semantics(
                            label: 'User name',
                            child: ResponsiveText(
                              text: userName,
                              style:
                                  Theme.of(context).textTheme.headlineMedium!,
                              baseFontSize: 20,
                            ),
                          ),
                          Semantics(
                            label: 'User email',
                            child: ResponsiveText(
                              text: userEmail,
                              style: Theme.of(context).textTheme.bodyMedium!,
                              baseFontSize: 14,
                            ),
                          ),
                        ] else ...[
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Semantics(
                                  label: 'Name input field',
                                  child: TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter a name';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Semantics(
                                  label: 'Email input field',
                                  child: TextFormField(
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter an email';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ]
                      ],
                    );
                  },
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: screenWidth * .30,
                  child: Semantics(
                    label: _isEditing ? 'Save changes' : 'Edit profile',
                    child: CustomElevatedButton(
                      text: context.translate(AppString.update),
                      onPressed: () async {
                        if (_isEditing) {
                          if (_formKey.currentState!.validate()) {
                            await updateUser.updateUserData(
                                _nameController.text, _emailController.text);
                            ref.refresh(userDataProvider);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Profile updated")),
                            );
                            setState(() {
                              _isEditing = false;
                            });
                          }
                        } else {
                          setState(() {
                            _isEditing = true;
                          });
                        }
                      },
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (!_isEditing) ...[
                  const Divider(),
                  const SizedBox(height: 10),
                  ListTile(
                    onTap: () async {
                      await logOut.signOut();
                      await Future.delayed(const Duration(microseconds: 1));
                      ref.refresh(userDataProvider);
                      if (ref.read(authServiceProvider).currentUser == null &&
                          context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Successfully logged out")),
                        );
                        if (context.mounted) {
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            Routes.loginRoute,
                            (Route<dynamic> route) => false,
                          );
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Logout failed")),
                          );
                        }
                      }
                    },
                    leading: const Icon(Icons.exit_to_app),
                    title: const ResponsiveText(
                      text: "Logout",
                      style: TextStyle(color: Colors.red),
                      baseFontSize: 16,
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      _showReportDialog(context);
                    },
                    leading: const Icon(Icons.send),
                    title: const ResponsiveText(
                      text: "Reports",
                      style: TextStyle(color: Colors.red),
                      baseFontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          text: context.translate(AppString.Email),
                          onPressed: () async {
                            await launchMethod('mailto:omareid720@gmail.com');
                          },
                          backgroundColor: Colors.blue,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: CustomElevatedButton(
                          text: context.translate(AppString.Phone),
                          onPressed: () async {
                            await launchMethod('tel:01554928896');
                          },
                          backgroundColor: Colors.blue,
                        ),
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Expanded(
                        child: CustomElevatedButton(
                          text: context.translate(AppString.Whats),
                          onPressed: () async {
                            await launchMethod('https://wa.me/01554928896');
                          },
                          backgroundColor: Colors.blue,
                        ),
                      ),
                    ],
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Report'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title field
                TextFormField(
                  controller: _reportTitleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _reportDescController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final title = _reportTitleController.text;
                  final description = _reportDescController.text;
                  await ref.read(authCrudProvider).addReport(
                      ref.read(authServiceProvider).currentUser!.uid,
                      title,
                      description);
                  if (context.mounted) {
                    Navigator.pop(context);
                    _reportTitleController.text = "";
                    _reportDescController.text = "";
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Report added')),
                    );
                  }
                }
              },
              child: Text(context.translate(AppString.Submit)),
            ),
          ],
        );
      },
    );
  }
}
