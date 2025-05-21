class RoutePath{
  const RoutePath._();

  // Full screen routes section
  static const initial = '/';
  static const splash = '/splash';
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const forgetPassword = '/forget-password';
  static const dashboard = '/dashboard';
  static const contact = '/contact';
  static const message = '/message';

  // Tab view routes section
  static const chat = '/chat';
  static const profile = '/profile';

  // Nested Tab view routes section
  static const editProfile = '$profile/edit-profile';
  static const setting = '$profile/setting';
  static const notification = '$profile/notiflcation';

}

class RouteName{
  const RouteName._();

  // Full screen routes section
  static const splash = 'splash';
  static const signIn = 'sign-in';
  static const signUp = 'sign-up';
  static const forgetPassword = 'forget-password';
  static const dashboard = 'dashboard';
  static const contact = 'contact';
  static const message = 'message';

  // Tab view routes section
  static const chat = 'chat';
  static const profile = 'profile';

  // Nested Tab view routes section
  static const editProfile = 'edit-profile';
  static const setting = 'setting';
  static const notification = 'notiflcation';

}
