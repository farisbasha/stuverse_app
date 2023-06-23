import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuverse_app/app/auth/cubit/auth_cubit.dart';
import 'package:stuverse_app/app/core/cubit/core_cubit.dart';

final blocProviderList = [
  BlocProvider<AuthCubit>(
    create: (context) => AuthCubit(),
  ),
  BlocProvider<CoreCubit>(
    create: (context) => CoreCubit(),
  ),
];
