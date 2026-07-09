// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskState {
  List<Task> get tasks;
  bool get isLoading;
  String? get errorMessage;
  bool get isMutating;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TaskStateCopyWith<TaskState> get copyWith =>
      _$TaskStateCopyWithImpl<TaskState>(this as TaskState, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TaskState &&
            const DeepCollectionEquality().equals(other.tasks, tasks) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.isMutating, isMutating) ||
                other.isMutating == isMutating));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(tasks),
      isLoading,
      errorMessage,
      isMutating);

  @override
  String toString() {
    return 'TaskState(tasks: $tasks, isLoading: $isLoading, errorMessage: $errorMessage, isMutating: $isMutating)';
  }
}

/// @nodoc
abstract mixin class $TaskStateCopyWith<$Res> {
  factory $TaskStateCopyWith(TaskState value, $Res Function(TaskState) _then) =
      _$TaskStateCopyWithImpl;
  @useResult
  $Res call(
      {List<Task> tasks,
      bool isLoading,
      String? errorMessage,
      bool isMutating});
}

/// @nodoc
class _$TaskStateCopyWithImpl<$Res> implements $TaskStateCopyWith<$Res> {
  _$TaskStateCopyWithImpl(this._self, this._then);

  final TaskState _self;
  final $Res Function(TaskState) _then;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tasks = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? isMutating = null,
  }) {
    return _then(_self.copyWith(
      tasks: null == tasks
          ? _self.tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Task>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isMutating: null == isMutating
          ? _self.isMutating
          : isMutating // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [TaskState].
extension TaskStatePatterns on TaskState {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_TaskState value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TaskState() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_TaskState value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskState():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_TaskState value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskState() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(List<Task> tasks, bool isLoading, String? errorMessage,
            bool isMutating)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TaskState() when $default != null:
        return $default(
            _that.tasks, _that.isLoading, _that.errorMessage, _that.isMutating);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(List<Task> tasks, bool isLoading, String? errorMessage,
            bool isMutating)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskState():
        return $default(
            _that.tasks, _that.isLoading, _that.errorMessage, _that.isMutating);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(List<Task> tasks, bool isLoading, String? errorMessage,
            bool isMutating)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TaskState() when $default != null:
        return $default(
            _that.tasks, _that.isLoading, _that.errorMessage, _that.isMutating);
      case _:
        return null;
    }
  }
}

/// @nodoc

class _TaskState implements TaskState {
  const _TaskState(
      {final List<Task> tasks = const [],
      this.isLoading = false,
      this.errorMessage,
      this.isMutating = false})
      : _tasks = tasks;

  final List<Task> _tasks;
  @override
  @JsonKey()
  List<Task> get tasks {
    if (_tasks is EqualUnmodifiableListView) return _tasks;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tasks);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final String? errorMessage;
  @override
  @JsonKey()
  final bool isMutating;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TaskStateCopyWith<_TaskState> get copyWith =>
      __$TaskStateCopyWithImpl<_TaskState>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TaskState &&
            const DeepCollectionEquality().equals(other._tasks, _tasks) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.isMutating, isMutating) ||
                other.isMutating == isMutating));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_tasks),
      isLoading,
      errorMessage,
      isMutating);

  @override
  String toString() {
    return 'TaskState(tasks: $tasks, isLoading: $isLoading, errorMessage: $errorMessage, isMutating: $isMutating)';
  }
}

/// @nodoc
abstract mixin class _$TaskStateCopyWith<$Res>
    implements $TaskStateCopyWith<$Res> {
  factory _$TaskStateCopyWith(
          _TaskState value, $Res Function(_TaskState) _then) =
      __$TaskStateCopyWithImpl;
  @override
  @useResult
  $Res call(
      {List<Task> tasks,
      bool isLoading,
      String? errorMessage,
      bool isMutating});
}

/// @nodoc
class __$TaskStateCopyWithImpl<$Res> implements _$TaskStateCopyWith<$Res> {
  __$TaskStateCopyWithImpl(this._self, this._then);

  final _TaskState _self;
  final $Res Function(_TaskState) _then;

  /// Create a copy of TaskState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? tasks = null,
    Object? isLoading = null,
    Object? errorMessage = freezed,
    Object? isMutating = null,
  }) {
    return _then(_TaskState(
      tasks: null == tasks
          ? _self._tasks
          : tasks // ignore: cast_nullable_to_non_nullable
              as List<Task>,
      isLoading: null == isLoading
          ? _self.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _self.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      isMutating: null == isMutating
          ? _self.isMutating
          : isMutating // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
