import 'package:flutter/cupertino.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_whatsapp_clone2/features/select_contacts/repository/select_contact_repository.dart';

final getContactsProvider = FutureProvider(
  (ref) {
    final selectContactRepository =
        ref.watch(selectContactsRepositoryProvider).getContacts();
    return selectContactRepository;
  },
);

final selectContactControllerProvider = Provider(
  (ref) {
    final selectContactRepository = ref.watch(selectContactsRepositoryProvider);
    return SelectContactController(
      ref: ref,
      selectContactRepository: selectContactRepository,
    );
  },
);

class SelectContactController {
  final ProviderRef ref;
  final SelectContactRepository selectContactRepository;

  SelectContactController({
    required this.ref,
    required this.selectContactRepository,
  });

  void selectContact(Contact selectedContact, BuildContext context) async {
    selectContactRepository.selectContact(selectedContact, context);
  }
}
