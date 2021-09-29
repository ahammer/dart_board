# dart_board_bloc

Bloc & Cubit Decoration Bindings

## Usage

Add BlocDecoration or CubitDecoration to your features.

```
  @override
  List<DartBoardDecoration> get appDecorations => [
        CubitDecoration((ctx) => CounterCubit()),
        BlocDecoration((ctx) => CounterBloc()),
      ];
```

No feature registration is required to use these decoration's in your feature.