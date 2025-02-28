// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// import 'package:http/http.dart' as http;
// import 'package:shopping_app/core/theme/theme.dart';
// import 'package:shopping_app/features/auth/data/repository/local%20repository/auth_repository_impl.dart';
// import 'package:shopping_app/features/home/view/home_viewpage.dart';
// import 'package:shopping_app/features/add%20to%20cart%20and%20order/domain/use_case/remove_from_cart.dart';

// import 'features/auth/data/data_source/remote_datasource/auth_remote_datasource.dart';
// import 'features/product/data/data_source/remote_datasource/shopping_remote_datasource.dart';
// import 'features/product/data/model/product_model.dart';
// import 'features/product/data/model/review_model.dart';
// import 'features/auth/data/model/user_hive_model.dart';
// import 'features/auth/presentation/view_model/bloc/auth/auth_bloc.dart';
// import 'features/product/presentation/view_model/bloc/shopping_bloc.dart';
// import 'features/product/data/repository/local_repository/shopping_repository_impl.dart';
// import 'features/auth/presentation/view/login_view.dart';
// import 'features/add to cart and order/domain/use_case/add_to_cart.dart';
// import 'features/product/domain/use_case/get_products_usecase.dart';
// import 'features/auth/domain/use_case/login_usecase.dart';
// import 'package:flutter_stripe/flutter_stripe.dart'; // Add this
// import 'features/auth/domain/use_case/register_usecase.dart';


// void main()async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   // Initialize Hive
//   await Hive.initFlutter();
//   Hive.registerAdapter(UserHiveModelAdapter());
//   Hive.registerAdapter(UserDataAdapter());
//   Hive.registerAdapter(AvatarAdapter());
//   Hive.registerAdapter(ProductModelAdapter()); // Must be here
//   Hive.registerAdapter(ImageModelAdapter());   // Must be here
//   Hive.registerAdapter(ReviewModelAdapter());
//   await Hive.openBox<ProductModel>('cartBox');
//   await Hive.openBox<ReviewModel>('reviewBox');
//   await Hive.openBox<ProductModel>('favoriteBox');
//   await Hive.openBox<UserHiveModel>('authBox'); // Open a box for auth data
 
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider(
//           create: (context) => AuthBloc(
//             Login(AuthRepositoryImpl(AuthRemoteDataSource(http.Client()))),
//             Register(AuthRepositoryImpl(AuthRemoteDataSource(http.Client()))),
//           ),
//         ),
//         BlocProvider(
//           create: (context) => ShoppingBloc(
//             GetProducts(ShoppingRepositoryImpl(ShoppingRemoteDataSource(http.Client()))),
//             AddToCart(ShoppingRepositoryImpl(ShoppingRemoteDataSource(http.Client()),)),
//             RemoveFromCart(ShoppingRepositoryImpl(ShoppingRemoteDataSource(http.Client()))),
//           ),
//         ),
//       ],
//       child: MaterialApp(
//         title: 'Shopping App',
//          theme: AppTheme.lightTheme,
//         debugShowCheckedModeBanner: false,
//         home: LoginPage(), // Start with login page
//       ),
//     );
//   }
// }