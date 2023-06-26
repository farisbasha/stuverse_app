import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stuverse_app/app/ads/cubit/ads_cubit.dart';
import 'package:stuverse_app/app/auth/cubit/auth_cubit.dart';
import 'package:stuverse_app/app/bot/cubit/bot_cubit.dart';
import 'package:stuverse_app/app/chat/cubit/chat_home_cubit.dart';
import 'package:stuverse_app/app/chat/cubit/chat_screen/chat_screen_cubit.dart';
import 'package:stuverse_app/app/core/cubit/ai_desc/ai_desc_cubit.dart';

import 'package:stuverse_app/app/core/cubit/core_cubit.dart';
import 'package:stuverse_app/app/core/cubit/main_page_cubit.dart';
import 'package:stuverse_app/app/core/cubit/product_add_edit/product_add_edit_cubit.dart';
import 'package:stuverse_app/app/core/cubit/report/report_cubit.dart';
import 'package:stuverse_app/app/home/cubit/home_cubit.dart';
import 'package:stuverse_app/app/profile/cubit/profile_edit_cubit.dart';
import 'package:stuverse_app/app/search/cubit/search_cubit.dart';

final blocProviderList = [
  BlocProvider<AuthCubit>(
    create: (context) => AuthCubit(),
  ),
  BlocProvider<CoreCubit>(
    create: (context) => CoreCubit(),
  ),
  BlocProvider<MainPageCubit>(
    create: (context) => MainPageCubit(),
  ),
  BlocProvider<HomeCubit>(
    create: (context) => HomeCubit(),
  ),
  BlocProvider<SearchCubit>(
    create: (context) => SearchCubit(),
  ),
  BlocProvider<ProfileEditCubit>(
    create: (context) => ProfileEditCubit(),
  ),
  BlocProvider<ProductAddEditCubit>(
    create: (context) => ProductAddEditCubit(),
  ),
  BlocProvider<AiDescCubit>(
    create: (context) => AiDescCubit(),
  ),
  BlocProvider<AdsCubit>(
    create: (context) => AdsCubit(),
  ),
  BlocProvider<BotCubit>(
    create: (context) => BotCubit(),
  ),
  BlocProvider<ReportCubit>(
    create: (context) => ReportCubit(),
  ),
  BlocProvider<ChatHomeCubit>(
    create: (context) => ChatHomeCubit(),
  ),
  BlocProvider<ChatScreenCubit>(
    create: (context) => ChatScreenCubit(),
  ),
];
