import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:messeconnect/features/masses/models/mass_type.dart';

void navigateToMass(BuildContext context, MassType type) {
  switch (type) {
    case MassType.nuptial:
      context.push('/mass/nuptiale');
      break;

    case MassType.guerison:
      context.push('/mass/guerison');
      break;

    case MassType.actionGrace:
      context.push('/mass/action-grace');
      break;

    case MassType.requiem:
      context.push('/mass/requiem');
      break;
  }
}
