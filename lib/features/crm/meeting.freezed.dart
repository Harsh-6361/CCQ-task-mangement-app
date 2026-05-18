// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Meeting {

 String get id; String get leadId; DateTime get date; String get feedback; DateTime? get followUpDate; String get ownerId;
/// Create a copy of Meeting
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingCopyWith<Meeting> get copyWith => _$MeetingCopyWithImpl<Meeting>(this as Meeting, _$identity);

  /// Serializes this Meeting to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Meeting&&(identical(other.id, id) || other.id == id)&&(identical(other.leadId, leadId) || other.leadId == leadId)&&(identical(other.date, date) || other.date == date)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&(identical(other.followUpDate, followUpDate) || other.followUpDate == followUpDate)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,leadId,date,feedback,followUpDate,ownerId);

@override
String toString() {
  return 'Meeting(id: $id, leadId: $leadId, date: $date, feedback: $feedback, followUpDate: $followUpDate, ownerId: $ownerId)';
}


}

/// @nodoc
abstract mixin class $MeetingCopyWith<$Res>  {
  factory $MeetingCopyWith(Meeting value, $Res Function(Meeting) _then) = _$MeetingCopyWithImpl;
@useResult
$Res call({
 String id, String leadId, DateTime date, String feedback, DateTime? followUpDate, String ownerId
});




}
/// @nodoc
class _$MeetingCopyWithImpl<$Res>
    implements $MeetingCopyWith<$Res> {
  _$MeetingCopyWithImpl(this._self, this._then);

  final Meeting _self;
  final $Res Function(Meeting) _then;

/// Create a copy of Meeting
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? leadId = null,Object? date = null,Object? feedback = null,Object? followUpDate = freezed,Object? ownerId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,leadId: null == leadId ? _self.leadId : leadId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,feedback: null == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String,followUpDate: freezed == followUpDate ? _self.followUpDate : followUpDate // ignore: cast_nullable_to_non_nullable
as DateTime?,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Meeting].
extension MeetingPatterns on Meeting {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Meeting value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Meeting() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Meeting value)  $default,){
final _that = this;
switch (_that) {
case _Meeting():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Meeting value)?  $default,){
final _that = this;
switch (_that) {
case _Meeting() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String leadId,  DateTime date,  String feedback,  DateTime? followUpDate,  String ownerId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Meeting() when $default != null:
return $default(_that.id,_that.leadId,_that.date,_that.feedback,_that.followUpDate,_that.ownerId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String leadId,  DateTime date,  String feedback,  DateTime? followUpDate,  String ownerId)  $default,) {final _that = this;
switch (_that) {
case _Meeting():
return $default(_that.id,_that.leadId,_that.date,_that.feedback,_that.followUpDate,_that.ownerId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String leadId,  DateTime date,  String feedback,  DateTime? followUpDate,  String ownerId)?  $default,) {final _that = this;
switch (_that) {
case _Meeting() when $default != null:
return $default(_that.id,_that.leadId,_that.date,_that.feedback,_that.followUpDate,_that.ownerId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Meeting implements Meeting {
  const _Meeting({required this.id, required this.leadId, required this.date, this.feedback = '', this.followUpDate, required this.ownerId});
  factory _Meeting.fromJson(Map<String, dynamic> json) => _$MeetingFromJson(json);

@override final  String id;
@override final  String leadId;
@override final  DateTime date;
@override@JsonKey() final  String feedback;
@override final  DateTime? followUpDate;
@override final  String ownerId;

/// Create a copy of Meeting
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingCopyWith<_Meeting> get copyWith => __$MeetingCopyWithImpl<_Meeting>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MeetingToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Meeting&&(identical(other.id, id) || other.id == id)&&(identical(other.leadId, leadId) || other.leadId == leadId)&&(identical(other.date, date) || other.date == date)&&(identical(other.feedback, feedback) || other.feedback == feedback)&&(identical(other.followUpDate, followUpDate) || other.followUpDate == followUpDate)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,leadId,date,feedback,followUpDate,ownerId);

@override
String toString() {
  return 'Meeting(id: $id, leadId: $leadId, date: $date, feedback: $feedback, followUpDate: $followUpDate, ownerId: $ownerId)';
}


}

/// @nodoc
abstract mixin class _$MeetingCopyWith<$Res> implements $MeetingCopyWith<$Res> {
  factory _$MeetingCopyWith(_Meeting value, $Res Function(_Meeting) _then) = __$MeetingCopyWithImpl;
@override @useResult
$Res call({
 String id, String leadId, DateTime date, String feedback, DateTime? followUpDate, String ownerId
});




}
/// @nodoc
class __$MeetingCopyWithImpl<$Res>
    implements _$MeetingCopyWith<$Res> {
  __$MeetingCopyWithImpl(this._self, this._then);

  final _Meeting _self;
  final $Res Function(_Meeting) _then;

/// Create a copy of Meeting
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? leadId = null,Object? date = null,Object? feedback = null,Object? followUpDate = freezed,Object? ownerId = null,}) {
  return _then(_Meeting(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,leadId: null == leadId ? _self.leadId : leadId // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,feedback: null == feedback ? _self.feedback : feedback // ignore: cast_nullable_to_non_nullable
as String,followUpDate: freezed == followUpDate ? _self.followUpDate : followUpDate // ignore: cast_nullable_to_non_nullable
as DateTime?,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
