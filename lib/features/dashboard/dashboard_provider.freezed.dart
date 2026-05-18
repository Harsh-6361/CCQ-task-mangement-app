// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'dashboard_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DashboardData {

 int get todoCount; int get inProgressCount; int get doneCount; List<Task> get upcomingTasks; List<Task> get assignedToMe; List<Meeting> get upcomingFollowUps; List<Task> get completedToday;
/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DashboardDataCopyWith<DashboardData> get copyWith => _$DashboardDataCopyWithImpl<DashboardData>(this as DashboardData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DashboardData&&(identical(other.todoCount, todoCount) || other.todoCount == todoCount)&&(identical(other.inProgressCount, inProgressCount) || other.inProgressCount == inProgressCount)&&(identical(other.doneCount, doneCount) || other.doneCount == doneCount)&&const DeepCollectionEquality().equals(other.upcomingTasks, upcomingTasks)&&const DeepCollectionEquality().equals(other.assignedToMe, assignedToMe)&&const DeepCollectionEquality().equals(other.upcomingFollowUps, upcomingFollowUps)&&const DeepCollectionEquality().equals(other.completedToday, completedToday));
}


@override
int get hashCode => Object.hash(runtimeType,todoCount,inProgressCount,doneCount,const DeepCollectionEquality().hash(upcomingTasks),const DeepCollectionEquality().hash(assignedToMe),const DeepCollectionEquality().hash(upcomingFollowUps),const DeepCollectionEquality().hash(completedToday));

@override
String toString() {
  return 'DashboardData(todoCount: $todoCount, inProgressCount: $inProgressCount, doneCount: $doneCount, upcomingTasks: $upcomingTasks, assignedToMe: $assignedToMe, upcomingFollowUps: $upcomingFollowUps, completedToday: $completedToday)';
}


}

/// @nodoc
abstract mixin class $DashboardDataCopyWith<$Res>  {
  factory $DashboardDataCopyWith(DashboardData value, $Res Function(DashboardData) _then) = _$DashboardDataCopyWithImpl;
@useResult
$Res call({
 int todoCount, int inProgressCount, int doneCount, List<Task> upcomingTasks, List<Task> assignedToMe, List<Meeting> upcomingFollowUps, List<Task> completedToday
});




}
/// @nodoc
class _$DashboardDataCopyWithImpl<$Res>
    implements $DashboardDataCopyWith<$Res> {
  _$DashboardDataCopyWithImpl(this._self, this._then);

  final DashboardData _self;
  final $Res Function(DashboardData) _then;

/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? todoCount = null,Object? inProgressCount = null,Object? doneCount = null,Object? upcomingTasks = null,Object? assignedToMe = null,Object? upcomingFollowUps = null,Object? completedToday = null,}) {
  return _then(_self.copyWith(
todoCount: null == todoCount ? _self.todoCount : todoCount // ignore: cast_nullable_to_non_nullable
as int,inProgressCount: null == inProgressCount ? _self.inProgressCount : inProgressCount // ignore: cast_nullable_to_non_nullable
as int,doneCount: null == doneCount ? _self.doneCount : doneCount // ignore: cast_nullable_to_non_nullable
as int,upcomingTasks: null == upcomingTasks ? _self.upcomingTasks : upcomingTasks // ignore: cast_nullable_to_non_nullable
as List<Task>,assignedToMe: null == assignedToMe ? _self.assignedToMe : assignedToMe // ignore: cast_nullable_to_non_nullable
as List<Task>,upcomingFollowUps: null == upcomingFollowUps ? _self.upcomingFollowUps : upcomingFollowUps // ignore: cast_nullable_to_non_nullable
as List<Meeting>,completedToday: null == completedToday ? _self.completedToday : completedToday // ignore: cast_nullable_to_non_nullable
as List<Task>,
  ));
}

}


/// Adds pattern-matching-related methods to [DashboardData].
extension DashboardDataPatterns on DashboardData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DashboardData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DashboardData value)  $default,){
final _that = this;
switch (_that) {
case _DashboardData():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DashboardData value)?  $default,){
final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int todoCount,  int inProgressCount,  int doneCount,  List<Task> upcomingTasks,  List<Task> assignedToMe,  List<Meeting> upcomingFollowUps,  List<Task> completedToday)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
return $default(_that.todoCount,_that.inProgressCount,_that.doneCount,_that.upcomingTasks,_that.assignedToMe,_that.upcomingFollowUps,_that.completedToday);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int todoCount,  int inProgressCount,  int doneCount,  List<Task> upcomingTasks,  List<Task> assignedToMe,  List<Meeting> upcomingFollowUps,  List<Task> completedToday)  $default,) {final _that = this;
switch (_that) {
case _DashboardData():
return $default(_that.todoCount,_that.inProgressCount,_that.doneCount,_that.upcomingTasks,_that.assignedToMe,_that.upcomingFollowUps,_that.completedToday);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int todoCount,  int inProgressCount,  int doneCount,  List<Task> upcomingTasks,  List<Task> assignedToMe,  List<Meeting> upcomingFollowUps,  List<Task> completedToday)?  $default,) {final _that = this;
switch (_that) {
case _DashboardData() when $default != null:
return $default(_that.todoCount,_that.inProgressCount,_that.doneCount,_that.upcomingTasks,_that.assignedToMe,_that.upcomingFollowUps,_that.completedToday);case _:
  return null;

}
}

}

/// @nodoc


class _DashboardData implements DashboardData {
  const _DashboardData({this.todoCount = 0, this.inProgressCount = 0, this.doneCount = 0, final  List<Task> upcomingTasks = const [], final  List<Task> assignedToMe = const [], final  List<Meeting> upcomingFollowUps = const [], final  List<Task> completedToday = const []}): _upcomingTasks = upcomingTasks,_assignedToMe = assignedToMe,_upcomingFollowUps = upcomingFollowUps,_completedToday = completedToday;
  

@override@JsonKey() final  int todoCount;
@override@JsonKey() final  int inProgressCount;
@override@JsonKey() final  int doneCount;
 final  List<Task> _upcomingTasks;
@override@JsonKey() List<Task> get upcomingTasks {
  if (_upcomingTasks is EqualUnmodifiableListView) return _upcomingTasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upcomingTasks);
}

 final  List<Task> _assignedToMe;
@override@JsonKey() List<Task> get assignedToMe {
  if (_assignedToMe is EqualUnmodifiableListView) return _assignedToMe;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assignedToMe);
}

 final  List<Meeting> _upcomingFollowUps;
@override@JsonKey() List<Meeting> get upcomingFollowUps {
  if (_upcomingFollowUps is EqualUnmodifiableListView) return _upcomingFollowUps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_upcomingFollowUps);
}

 final  List<Task> _completedToday;
@override@JsonKey() List<Task> get completedToday {
  if (_completedToday is EqualUnmodifiableListView) return _completedToday;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_completedToday);
}


/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DashboardDataCopyWith<_DashboardData> get copyWith => __$DashboardDataCopyWithImpl<_DashboardData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DashboardData&&(identical(other.todoCount, todoCount) || other.todoCount == todoCount)&&(identical(other.inProgressCount, inProgressCount) || other.inProgressCount == inProgressCount)&&(identical(other.doneCount, doneCount) || other.doneCount == doneCount)&&const DeepCollectionEquality().equals(other._upcomingTasks, _upcomingTasks)&&const DeepCollectionEquality().equals(other._assignedToMe, _assignedToMe)&&const DeepCollectionEquality().equals(other._upcomingFollowUps, _upcomingFollowUps)&&const DeepCollectionEquality().equals(other._completedToday, _completedToday));
}


@override
int get hashCode => Object.hash(runtimeType,todoCount,inProgressCount,doneCount,const DeepCollectionEquality().hash(_upcomingTasks),const DeepCollectionEquality().hash(_assignedToMe),const DeepCollectionEquality().hash(_upcomingFollowUps),const DeepCollectionEquality().hash(_completedToday));

@override
String toString() {
  return 'DashboardData(todoCount: $todoCount, inProgressCount: $inProgressCount, doneCount: $doneCount, upcomingTasks: $upcomingTasks, assignedToMe: $assignedToMe, upcomingFollowUps: $upcomingFollowUps, completedToday: $completedToday)';
}


}

/// @nodoc
abstract mixin class _$DashboardDataCopyWith<$Res> implements $DashboardDataCopyWith<$Res> {
  factory _$DashboardDataCopyWith(_DashboardData value, $Res Function(_DashboardData) _then) = __$DashboardDataCopyWithImpl;
@override @useResult
$Res call({
 int todoCount, int inProgressCount, int doneCount, List<Task> upcomingTasks, List<Task> assignedToMe, List<Meeting> upcomingFollowUps, List<Task> completedToday
});




}
/// @nodoc
class __$DashboardDataCopyWithImpl<$Res>
    implements _$DashboardDataCopyWith<$Res> {
  __$DashboardDataCopyWithImpl(this._self, this._then);

  final _DashboardData _self;
  final $Res Function(_DashboardData) _then;

/// Create a copy of DashboardData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? todoCount = null,Object? inProgressCount = null,Object? doneCount = null,Object? upcomingTasks = null,Object? assignedToMe = null,Object? upcomingFollowUps = null,Object? completedToday = null,}) {
  return _then(_DashboardData(
todoCount: null == todoCount ? _self.todoCount : todoCount // ignore: cast_nullable_to_non_nullable
as int,inProgressCount: null == inProgressCount ? _self.inProgressCount : inProgressCount // ignore: cast_nullable_to_non_nullable
as int,doneCount: null == doneCount ? _self.doneCount : doneCount // ignore: cast_nullable_to_non_nullable
as int,upcomingTasks: null == upcomingTasks ? _self._upcomingTasks : upcomingTasks // ignore: cast_nullable_to_non_nullable
as List<Task>,assignedToMe: null == assignedToMe ? _self._assignedToMe : assignedToMe // ignore: cast_nullable_to_non_nullable
as List<Task>,upcomingFollowUps: null == upcomingFollowUps ? _self._upcomingFollowUps : upcomingFollowUps // ignore: cast_nullable_to_non_nullable
as List<Meeting>,completedToday: null == completedToday ? _self._completedToday : completedToday // ignore: cast_nullable_to_non_nullable
as List<Task>,
  ));
}


}

// dart format on
