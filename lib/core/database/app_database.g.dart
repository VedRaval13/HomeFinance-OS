// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DeviceInfoTableTable extends DeviceInfoTable
    with TableInfo<$DeviceInfoTableTable, DeviceInfoEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeviceInfoTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deviceModelMeta = const VerificationMeta(
    'deviceModel',
  );
  @override
  late final GeneratedColumn<String> deviceModel = GeneratedColumn<String>(
    'device_model',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _osVersionMeta = const VerificationMeta(
    'osVersion',
  );
  @override
  late final GeneratedColumn<String> osVersion = GeneratedColumn<String>(
    'os_version',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _appVersionMeta = const VerificationMeta(
    'appVersion',
  );
  @override
  late final GeneratedColumn<String> appVersion = GeneratedColumn<String>(
    'app_version',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastOpenedAtMeta = const VerificationMeta(
    'lastOpenedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastOpenedAt = GeneratedColumn<DateTime>(
    'last_opened_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deviceModel,
    osVersion,
    appVersion,
    createdAt,
    lastOpenedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'device_info';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeviceInfoEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('device_model')) {
      context.handle(
        _deviceModelMeta,
        deviceModel.isAcceptableOrUnknown(
          data['device_model']!,
          _deviceModelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_deviceModelMeta);
    }
    if (data.containsKey('os_version')) {
      context.handle(
        _osVersionMeta,
        osVersion.isAcceptableOrUnknown(data['os_version']!, _osVersionMeta),
      );
    } else if (isInserting) {
      context.missing(_osVersionMeta);
    }
    if (data.containsKey('app_version')) {
      context.handle(
        _appVersionMeta,
        appVersion.isAcceptableOrUnknown(data['app_version']!, _appVersionMeta),
      );
    } else if (isInserting) {
      context.missing(_appVersionMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('last_opened_at')) {
      context.handle(
        _lastOpenedAtMeta,
        lastOpenedAt.isAcceptableOrUnknown(
          data['last_opened_at']!,
          _lastOpenedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastOpenedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeviceInfoEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeviceInfoEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      deviceModel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_model'],
      )!,
      osVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}os_version'],
      )!,
      appVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}app_version'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      lastOpenedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_opened_at'],
      )!,
    );
  }

  @override
  $DeviceInfoTableTable createAlias(String alias) {
    return $DeviceInfoTableTable(attachedDatabase, alias);
  }
}

class DeviceInfoEntry extends DataClass implements Insertable<DeviceInfoEntry> {
  final String id;
  final String deviceModel;
  final String osVersion;
  final String appVersion;
  final DateTime createdAt;
  final DateTime lastOpenedAt;
  const DeviceInfoEntry({
    required this.id,
    required this.deviceModel,
    required this.osVersion,
    required this.appVersion,
    required this.createdAt,
    required this.lastOpenedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['device_model'] = Variable<String>(deviceModel);
    map['os_version'] = Variable<String>(osVersion);
    map['app_version'] = Variable<String>(appVersion);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['last_opened_at'] = Variable<DateTime>(lastOpenedAt);
    return map;
  }

  DeviceInfoTableCompanion toCompanion(bool nullToAbsent) {
    return DeviceInfoTableCompanion(
      id: Value(id),
      deviceModel: Value(deviceModel),
      osVersion: Value(osVersion),
      appVersion: Value(appVersion),
      createdAt: Value(createdAt),
      lastOpenedAt: Value(lastOpenedAt),
    );
  }

  factory DeviceInfoEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeviceInfoEntry(
      id: serializer.fromJson<String>(json['id']),
      deviceModel: serializer.fromJson<String>(json['deviceModel']),
      osVersion: serializer.fromJson<String>(json['osVersion']),
      appVersion: serializer.fromJson<String>(json['appVersion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      lastOpenedAt: serializer.fromJson<DateTime>(json['lastOpenedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deviceModel': serializer.toJson<String>(deviceModel),
      'osVersion': serializer.toJson<String>(osVersion),
      'appVersion': serializer.toJson<String>(appVersion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'lastOpenedAt': serializer.toJson<DateTime>(lastOpenedAt),
    };
  }

  DeviceInfoEntry copyWith({
    String? id,
    String? deviceModel,
    String? osVersion,
    String? appVersion,
    DateTime? createdAt,
    DateTime? lastOpenedAt,
  }) => DeviceInfoEntry(
    id: id ?? this.id,
    deviceModel: deviceModel ?? this.deviceModel,
    osVersion: osVersion ?? this.osVersion,
    appVersion: appVersion ?? this.appVersion,
    createdAt: createdAt ?? this.createdAt,
    lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
  );
  DeviceInfoEntry copyWithCompanion(DeviceInfoTableCompanion data) {
    return DeviceInfoEntry(
      id: data.id.present ? data.id.value : this.id,
      deviceModel: data.deviceModel.present
          ? data.deviceModel.value
          : this.deviceModel,
      osVersion: data.osVersion.present ? data.osVersion.value : this.osVersion,
      appVersion: data.appVersion.present
          ? data.appVersion.value
          : this.appVersion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastOpenedAt: data.lastOpenedAt.present
          ? data.lastOpenedAt.value
          : this.lastOpenedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeviceInfoEntry(')
          ..write('id: $id, ')
          ..write('deviceModel: $deviceModel, ')
          ..write('osVersion: $osVersion, ')
          ..write('appVersion: $appVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastOpenedAt: $lastOpenedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deviceModel,
    osVersion,
    appVersion,
    createdAt,
    lastOpenedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeviceInfoEntry &&
          other.id == this.id &&
          other.deviceModel == this.deviceModel &&
          other.osVersion == this.osVersion &&
          other.appVersion == this.appVersion &&
          other.createdAt == this.createdAt &&
          other.lastOpenedAt == this.lastOpenedAt);
}

class DeviceInfoTableCompanion extends UpdateCompanion<DeviceInfoEntry> {
  final Value<String> id;
  final Value<String> deviceModel;
  final Value<String> osVersion;
  final Value<String> appVersion;
  final Value<DateTime> createdAt;
  final Value<DateTime> lastOpenedAt;
  final Value<int> rowid;
  const DeviceInfoTableCompanion({
    this.id = const Value.absent(),
    this.deviceModel = const Value.absent(),
    this.osVersion = const Value.absent(),
    this.appVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastOpenedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeviceInfoTableCompanion.insert({
    required String id,
    required String deviceModel,
    required String osVersion,
    required String appVersion,
    required DateTime createdAt,
    required DateTime lastOpenedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       deviceModel = Value(deviceModel),
       osVersion = Value(osVersion),
       appVersion = Value(appVersion),
       createdAt = Value(createdAt),
       lastOpenedAt = Value(lastOpenedAt);
  static Insertable<DeviceInfoEntry> custom({
    Expression<String>? id,
    Expression<String>? deviceModel,
    Expression<String>? osVersion,
    Expression<String>? appVersion,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? lastOpenedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deviceModel != null) 'device_model': deviceModel,
      if (osVersion != null) 'os_version': osVersion,
      if (appVersion != null) 'app_version': appVersion,
      if (createdAt != null) 'created_at': createdAt,
      if (lastOpenedAt != null) 'last_opened_at': lastOpenedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeviceInfoTableCompanion copyWith({
    Value<String>? id,
    Value<String>? deviceModel,
    Value<String>? osVersion,
    Value<String>? appVersion,
    Value<DateTime>? createdAt,
    Value<DateTime>? lastOpenedAt,
    Value<int>? rowid,
  }) {
    return DeviceInfoTableCompanion(
      id: id ?? this.id,
      deviceModel: deviceModel ?? this.deviceModel,
      osVersion: osVersion ?? this.osVersion,
      appVersion: appVersion ?? this.appVersion,
      createdAt: createdAt ?? this.createdAt,
      lastOpenedAt: lastOpenedAt ?? this.lastOpenedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deviceModel.present) {
      map['device_model'] = Variable<String>(deviceModel.value);
    }
    if (osVersion.present) {
      map['os_version'] = Variable<String>(osVersion.value);
    }
    if (appVersion.present) {
      map['app_version'] = Variable<String>(appVersion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (lastOpenedAt.present) {
      map['last_opened_at'] = Variable<DateTime>(lastOpenedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeviceInfoTableCompanion(')
          ..write('id: $id, ')
          ..write('deviceModel: $deviceModel, ')
          ..write('osVersion: $osVersion, ')
          ..write('appVersion: $appVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastOpenedAt: $lastOpenedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $UserProfileTableTable extends UserProfileTable
    with TableInfo<$UserProfileTableTable, UserProfileEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfileTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 120),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _primaryCurrencyMeta = const VerificationMeta(
    'primaryCurrency',
  );
  @override
  late final GeneratedColumn<String> primaryCurrency = GeneratedColumn<String>(
    'primary_currency',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    email,
    primaryCurrency,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profile';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfileEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    }
    if (data.containsKey('primary_currency')) {
      context.handle(
        _primaryCurrencyMeta,
        primaryCurrency.isAcceptableOrUnknown(
          data['primary_currency']!,
          _primaryCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfileEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfileEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      ),
      primaryCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}primary_currency'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UserProfileTableTable createAlias(String alias) {
    return $UserProfileTableTable(attachedDatabase, alias);
  }
}

class UserProfileEntry extends DataClass
    implements Insertable<UserProfileEntry> {
  final String id;
  final String displayName;
  final String? email;
  final String primaryCurrency;
  final DateTime createdAt;
  final DateTime updatedAt;
  const UserProfileEntry({
    required this.id,
    required this.displayName,
    this.email,
    required this.primaryCurrency,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    if (!nullToAbsent || email != null) {
      map['email'] = Variable<String>(email);
    }
    map['primary_currency'] = Variable<String>(primaryCurrency);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UserProfileTableCompanion toCompanion(bool nullToAbsent) {
    return UserProfileTableCompanion(
      id: Value(id),
      displayName: Value(displayName),
      email: email == null && nullToAbsent
          ? const Value.absent()
          : Value(email),
      primaryCurrency: Value(primaryCurrency),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory UserProfileEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfileEntry(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      email: serializer.fromJson<String?>(json['email']),
      primaryCurrency: serializer.fromJson<String>(json['primaryCurrency']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String>(displayName),
      'email': serializer.toJson<String?>(email),
      'primaryCurrency': serializer.toJson<String>(primaryCurrency),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  UserProfileEntry copyWith({
    String? id,
    String? displayName,
    Value<String?> email = const Value.absent(),
    String? primaryCurrency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => UserProfileEntry(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    email: email.present ? email.value : this.email,
    primaryCurrency: primaryCurrency ?? this.primaryCurrency,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  UserProfileEntry copyWithCompanion(UserProfileTableCompanion data) {
    return UserProfileEntry(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      email: data.email.present ? data.email.value : this.email,
      primaryCurrency: data.primaryCurrency.present
          ? data.primaryCurrency.value
          : this.primaryCurrency,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileEntry(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('email: $email, ')
          ..write('primaryCurrency: $primaryCurrency, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    email,
    primaryCurrency,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfileEntry &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.email == this.email &&
          other.primaryCurrency == this.primaryCurrency &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UserProfileTableCompanion extends UpdateCompanion<UserProfileEntry> {
  final Value<String> id;
  final Value<String> displayName;
  final Value<String?> email;
  final Value<String> primaryCurrency;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UserProfileTableCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.email = const Value.absent(),
    this.primaryCurrency = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UserProfileTableCompanion.insert({
    required String id,
    required String displayName,
    this.email = const Value.absent(),
    this.primaryCurrency = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       displayName = Value(displayName),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<UserProfileEntry> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<String>? email,
    Expression<String>? primaryCurrency,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (email != null) 'email': email,
      if (primaryCurrency != null) 'primary_currency': primaryCurrency,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UserProfileTableCompanion copyWith({
    Value<String>? id,
    Value<String>? displayName,
    Value<String?>? email,
    Value<String>? primaryCurrency,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UserProfileTableCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      primaryCurrency: primaryCurrency ?? this.primaryCurrency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (primaryCurrency.present) {
      map['primary_currency'] = Variable<String>(primaryCurrency.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfileTableCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('email: $email, ')
          ..write('primaryCurrency: $primaryCurrency, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FamilyMembersTableTable extends FamilyMembersTable
    with TableInfo<$FamilyMembersTableTable, FamilyMemberEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FamilyMembersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avatarPathMeta = const VerificationMeta(
    'avatarPath',
  );
  @override
  late final GeneratedColumn<String> avatarPath = GeneratedColumn<String>(
    'avatar_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 7,
      maxTextLength: 9,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#00796B'),
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    role,
    avatarPath,
    colorHex,
    isActive,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'family_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<FamilyMemberEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    } else if (isInserting) {
      context.missing(_roleMeta);
    }
    if (data.containsKey('avatar_path')) {
      context.handle(
        _avatarPathMeta,
        avatarPath.isAcceptableOrUnknown(data['avatar_path']!, _avatarPathMeta),
      );
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FamilyMemberEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FamilyMemberEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      avatarPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}avatar_path'],
      ),
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $FamilyMembersTableTable createAlias(String alias) {
    return $FamilyMembersTableTable(attachedDatabase, alias);
  }
}

class FamilyMemberEntry extends DataClass
    implements Insertable<FamilyMemberEntry> {
  final String id;
  final String name;
  final String role;
  final String? avatarPath;
  final String colorHex;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;
  const FamilyMemberEntry({
    required this.id,
    required this.name,
    required this.role,
    this.avatarPath,
    required this.colorHex,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['role'] = Variable<String>(role);
    if (!nullToAbsent || avatarPath != null) {
      map['avatar_path'] = Variable<String>(avatarPath);
    }
    map['color_hex'] = Variable<String>(colorHex);
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  FamilyMembersTableCompanion toCompanion(bool nullToAbsent) {
    return FamilyMembersTableCompanion(
      id: Value(id),
      name: Value(name),
      role: Value(role),
      avatarPath: avatarPath == null && nullToAbsent
          ? const Value.absent()
          : Value(avatarPath),
      colorHex: Value(colorHex),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory FamilyMemberEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FamilyMemberEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      role: serializer.fromJson<String>(json['role']),
      avatarPath: serializer.fromJson<String?>(json['avatarPath']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'role': serializer.toJson<String>(role),
      'avatarPath': serializer.toJson<String?>(avatarPath),
      'colorHex': serializer.toJson<String>(colorHex),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  FamilyMemberEntry copyWith({
    String? id,
    String? name,
    String? role,
    Value<String?> avatarPath = const Value.absent(),
    String? colorHex,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => FamilyMemberEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    role: role ?? this.role,
    avatarPath: avatarPath.present ? avatarPath.value : this.avatarPath,
    colorHex: colorHex ?? this.colorHex,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  FamilyMemberEntry copyWithCompanion(FamilyMembersTableCompanion data) {
    return FamilyMemberEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      role: data.role.present ? data.role.value : this.role,
      avatarPath: data.avatarPath.present
          ? data.avatarPath.value
          : this.avatarPath,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FamilyMemberEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('colorHex: $colorHex, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    role,
    avatarPath,
    colorHex,
    isActive,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FamilyMemberEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.role == this.role &&
          other.avatarPath == this.avatarPath &&
          other.colorHex == this.colorHex &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class FamilyMembersTableCompanion extends UpdateCompanion<FamilyMemberEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> role;
  final Value<String?> avatarPath;
  final Value<String> colorHex;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const FamilyMembersTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.role = const Value.absent(),
    this.avatarPath = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FamilyMembersTableCompanion.insert({
    required String id,
    required String name,
    required String role,
    this.avatarPath = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       role = Value(role),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<FamilyMemberEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? role,
    Expression<String>? avatarPath,
    Expression<String>? colorHex,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (role != null) 'role': role,
      if (avatarPath != null) 'avatar_path': avatarPath,
      if (colorHex != null) 'color_hex': colorHex,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FamilyMembersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? role,
    Value<String?>? avatarPath,
    Value<String>? colorHex,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return FamilyMembersTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      avatarPath: avatarPath ?? this.avatarPath,
      colorHex: colorHex ?? this.colorHex,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (avatarPath.present) {
      map['avatar_path'] = Variable<String>(avatarPath.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FamilyMembersTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('role: $role, ')
          ..write('avatarPath: $avatarPath, ')
          ..write('colorHex: $colorHex, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FinancialSpacesTableTable extends FinancialSpacesTable
    with TableInfo<$FinancialSpacesTableTable, FinancialSpaceEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FinancialSpacesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES family_members (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    scope,
    memberId,
    isDefault,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'financial_spaces';
  @override
  VerificationContext validateIntegrity(
    Insertable<FinancialSpaceEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FinancialSpaceEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FinancialSpaceEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      scope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      ),
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $FinancialSpacesTableTable createAlias(String alias) {
    return $FinancialSpacesTableTable(attachedDatabase, alias);
  }
}

class FinancialSpaceEntry extends DataClass
    implements Insertable<FinancialSpaceEntry> {
  final String id;
  final String name;
  final String scope;
  final String? memberId;
  final bool isDefault;
  final DateTime createdAt;
  const FinancialSpaceEntry({
    required this.id,
    required this.name,
    required this.scope,
    this.memberId,
    required this.isDefault,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['scope'] = Variable<String>(scope);
    if (!nullToAbsent || memberId != null) {
      map['member_id'] = Variable<String>(memberId);
    }
    map['is_default'] = Variable<bool>(isDefault);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  FinancialSpacesTableCompanion toCompanion(bool nullToAbsent) {
    return FinancialSpacesTableCompanion(
      id: Value(id),
      name: Value(name),
      scope: Value(scope),
      memberId: memberId == null && nullToAbsent
          ? const Value.absent()
          : Value(memberId),
      isDefault: Value(isDefault),
      createdAt: Value(createdAt),
    );
  }

  factory FinancialSpaceEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FinancialSpaceEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      scope: serializer.fromJson<String>(json['scope']),
      memberId: serializer.fromJson<String?>(json['memberId']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'scope': serializer.toJson<String>(scope),
      'memberId': serializer.toJson<String?>(memberId),
      'isDefault': serializer.toJson<bool>(isDefault),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  FinancialSpaceEntry copyWith({
    String? id,
    String? name,
    String? scope,
    Value<String?> memberId = const Value.absent(),
    bool? isDefault,
    DateTime? createdAt,
  }) => FinancialSpaceEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    scope: scope ?? this.scope,
    memberId: memberId.present ? memberId.value : this.memberId,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt ?? this.createdAt,
  );
  FinancialSpaceEntry copyWithCompanion(FinancialSpacesTableCompanion data) {
    return FinancialSpaceEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      scope: data.scope.present ? data.scope.value : this.scope,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FinancialSpaceEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('scope: $scope, ')
          ..write('memberId: $memberId, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, name, scope, memberId, isDefault, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FinancialSpaceEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.scope == this.scope &&
          other.memberId == this.memberId &&
          other.isDefault == this.isDefault &&
          other.createdAt == this.createdAt);
}

class FinancialSpacesTableCompanion
    extends UpdateCompanion<FinancialSpaceEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> scope;
  final Value<String?> memberId;
  final Value<bool> isDefault;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const FinancialSpacesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.scope = const Value.absent(),
    this.memberId = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FinancialSpacesTableCompanion.insert({
    required String id,
    required String name,
    required String scope,
    this.memberId = const Value.absent(),
    this.isDefault = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       scope = Value(scope),
       createdAt = Value(createdAt);
  static Insertable<FinancialSpaceEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? scope,
    Expression<String>? memberId,
    Expression<bool>? isDefault,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (scope != null) 'scope': scope,
      if (memberId != null) 'member_id': memberId,
      if (isDefault != null) 'is_default': isDefault,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FinancialSpacesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? scope,
    Value<String?>? memberId,
    Value<bool>? isDefault,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return FinancialSpacesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      scope: scope ?? this.scope,
      memberId: memberId ?? this.memberId,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FinancialSpacesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('scope: $scope, ')
          ..write('memberId: $memberId, ')
          ..write('isDefault: $isDefault, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AccountsTableTable extends AccountsTable
    with TableInfo<$AccountsTableTable, AccountEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountTypeMeta = const VerificationMeta(
    'accountType',
  );
  @override
  late final GeneratedColumn<String> accountType = GeneratedColumn<String>(
    'account_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES family_members (id) ON DELETE SET NULL',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Money, int> initialBalance =
      GeneratedColumn<int>(
        'initial_balance',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Money>($AccountsTableTable.$converterinitialBalance);
  @override
  late final GeneratedColumnWithTypeConverter<Money, int> currentBalance =
      GeneratedColumn<int>(
        'current_balance',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Money>($AccountsTableTable.$convertercurrentBalance);
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 3,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('INR'),
  );
  static const VerificationMeta _institutionNameMeta = const VerificationMeta(
    'institutionName',
  );
  @override
  late final GeneratedColumn<String> institutionName = GeneratedColumn<String>(
    'institution_name',
    aliasedName,
    true,
    additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 120),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountNumberLast4Meta =
      const VerificationMeta('accountNumberLast4');
  @override
  late final GeneratedColumn<String> accountNumberLast4 =
      GeneratedColumn<String>(
        'account_number_last4',
        aliasedName,
        true,
        additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 10),
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    accountType,
    scope,
    memberId,
    initialBalance,
    currentBalance,
    currencyCode,
    institutionName,
    accountNumberLast4,
    isArchived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<AccountEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('account_type')) {
      context.handle(
        _accountTypeMeta,
        accountType.isAcceptableOrUnknown(
          data['account_type']!,
          _accountTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accountTypeMeta);
    }
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('institution_name')) {
      context.handle(
        _institutionNameMeta,
        institutionName.isAcceptableOrUnknown(
          data['institution_name']!,
          _institutionNameMeta,
        ),
      );
    }
    if (data.containsKey('account_number_last4')) {
      context.handle(
        _accountNumberLast4Meta,
        accountNumberLast4.isAcceptableOrUnknown(
          data['account_number_last4']!,
          _accountNumberLast4Meta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AccountEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AccountEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      accountType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_type'],
      )!,
      scope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      ),
      initialBalance: $AccountsTableTable.$converterinitialBalance.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}initial_balance'],
        )!,
      ),
      currentBalance: $AccountsTableTable.$convertercurrentBalance.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}current_balance'],
        )!,
      ),
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      institutionName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}institution_name'],
      ),
      accountNumberLast4: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_number_last4'],
      ),
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AccountsTableTable createAlias(String alias) {
    return $AccountsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Money, int> $converterinitialBalance =
      const MoneyConverter();
  static TypeConverter<Money, int> $convertercurrentBalance =
      const MoneyConverter();
}

class AccountEntry extends DataClass implements Insertable<AccountEntry> {
  final String id;
  final String name;
  final String accountType;
  final String scope;
  final String? memberId;
  final Money initialBalance;
  final Money currentBalance;
  final String currencyCode;
  final String? institutionName;
  final String? accountNumberLast4;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AccountEntry({
    required this.id,
    required this.name,
    required this.accountType,
    required this.scope,
    this.memberId,
    required this.initialBalance,
    required this.currentBalance,
    required this.currencyCode,
    this.institutionName,
    this.accountNumberLast4,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['account_type'] = Variable<String>(accountType);
    map['scope'] = Variable<String>(scope);
    if (!nullToAbsent || memberId != null) {
      map['member_id'] = Variable<String>(memberId);
    }
    {
      map['initial_balance'] = Variable<int>(
        $AccountsTableTable.$converterinitialBalance.toSql(initialBalance),
      );
    }
    {
      map['current_balance'] = Variable<int>(
        $AccountsTableTable.$convertercurrentBalance.toSql(currentBalance),
      );
    }
    map['currency_code'] = Variable<String>(currencyCode);
    if (!nullToAbsent || institutionName != null) {
      map['institution_name'] = Variable<String>(institutionName);
    }
    if (!nullToAbsent || accountNumberLast4 != null) {
      map['account_number_last4'] = Variable<String>(accountNumberLast4);
    }
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AccountsTableCompanion toCompanion(bool nullToAbsent) {
    return AccountsTableCompanion(
      id: Value(id),
      name: Value(name),
      accountType: Value(accountType),
      scope: Value(scope),
      memberId: memberId == null && nullToAbsent
          ? const Value.absent()
          : Value(memberId),
      initialBalance: Value(initialBalance),
      currentBalance: Value(currentBalance),
      currencyCode: Value(currencyCode),
      institutionName: institutionName == null && nullToAbsent
          ? const Value.absent()
          : Value(institutionName),
      accountNumberLast4: accountNumberLast4 == null && nullToAbsent
          ? const Value.absent()
          : Value(accountNumberLast4),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AccountEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AccountEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      accountType: serializer.fromJson<String>(json['accountType']),
      scope: serializer.fromJson<String>(json['scope']),
      memberId: serializer.fromJson<String?>(json['memberId']),
      initialBalance: serializer.fromJson<Money>(json['initialBalance']),
      currentBalance: serializer.fromJson<Money>(json['currentBalance']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      institutionName: serializer.fromJson<String?>(json['institutionName']),
      accountNumberLast4: serializer.fromJson<String?>(
        json['accountNumberLast4'],
      ),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'accountType': serializer.toJson<String>(accountType),
      'scope': serializer.toJson<String>(scope),
      'memberId': serializer.toJson<String?>(memberId),
      'initialBalance': serializer.toJson<Money>(initialBalance),
      'currentBalance': serializer.toJson<Money>(currentBalance),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'institutionName': serializer.toJson<String?>(institutionName),
      'accountNumberLast4': serializer.toJson<String?>(accountNumberLast4),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AccountEntry copyWith({
    String? id,
    String? name,
    String? accountType,
    String? scope,
    Value<String?> memberId = const Value.absent(),
    Money? initialBalance,
    Money? currentBalance,
    String? currencyCode,
    Value<String?> institutionName = const Value.absent(),
    Value<String?> accountNumberLast4 = const Value.absent(),
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AccountEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    accountType: accountType ?? this.accountType,
    scope: scope ?? this.scope,
    memberId: memberId.present ? memberId.value : this.memberId,
    initialBalance: initialBalance ?? this.initialBalance,
    currentBalance: currentBalance ?? this.currentBalance,
    currencyCode: currencyCode ?? this.currencyCode,
    institutionName: institutionName.present
        ? institutionName.value
        : this.institutionName,
    accountNumberLast4: accountNumberLast4.present
        ? accountNumberLast4.value
        : this.accountNumberLast4,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AccountEntry copyWithCompanion(AccountsTableCompanion data) {
    return AccountEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      accountType: data.accountType.present
          ? data.accountType.value
          : this.accountType,
      scope: data.scope.present ? data.scope.value : this.scope,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      initialBalance: data.initialBalance.present
          ? data.initialBalance.value
          : this.initialBalance,
      currentBalance: data.currentBalance.present
          ? data.currentBalance.value
          : this.currentBalance,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      institutionName: data.institutionName.present
          ? data.institutionName.value
          : this.institutionName,
      accountNumberLast4: data.accountNumberLast4.present
          ? data.accountNumberLast4.value
          : this.accountNumberLast4,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AccountEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('accountType: $accountType, ')
          ..write('scope: $scope, ')
          ..write('memberId: $memberId, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('institutionName: $institutionName, ')
          ..write('accountNumberLast4: $accountNumberLast4, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    accountType,
    scope,
    memberId,
    initialBalance,
    currentBalance,
    currencyCode,
    institutionName,
    accountNumberLast4,
    isArchived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AccountEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.accountType == this.accountType &&
          other.scope == this.scope &&
          other.memberId == this.memberId &&
          other.initialBalance == this.initialBalance &&
          other.currentBalance == this.currentBalance &&
          other.currencyCode == this.currencyCode &&
          other.institutionName == this.institutionName &&
          other.accountNumberLast4 == this.accountNumberLast4 &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AccountsTableCompanion extends UpdateCompanion<AccountEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> accountType;
  final Value<String> scope;
  final Value<String?> memberId;
  final Value<Money> initialBalance;
  final Value<Money> currentBalance;
  final Value<String> currencyCode;
  final Value<String?> institutionName;
  final Value<String?> accountNumberLast4;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AccountsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.accountType = const Value.absent(),
    this.scope = const Value.absent(),
    this.memberId = const Value.absent(),
    this.initialBalance = const Value.absent(),
    this.currentBalance = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.institutionName = const Value.absent(),
    this.accountNumberLast4 = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsTableCompanion.insert({
    required String id,
    required String name,
    required String accountType,
    required String scope,
    this.memberId = const Value.absent(),
    required Money initialBalance,
    required Money currentBalance,
    this.currencyCode = const Value.absent(),
    this.institutionName = const Value.absent(),
    this.accountNumberLast4 = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       accountType = Value(accountType),
       scope = Value(scope),
       initialBalance = Value(initialBalance),
       currentBalance = Value(currentBalance),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AccountEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? accountType,
    Expression<String>? scope,
    Expression<String>? memberId,
    Expression<int>? initialBalance,
    Expression<int>? currentBalance,
    Expression<String>? currencyCode,
    Expression<String>? institutionName,
    Expression<String>? accountNumberLast4,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (accountType != null) 'account_type': accountType,
      if (scope != null) 'scope': scope,
      if (memberId != null) 'member_id': memberId,
      if (initialBalance != null) 'initial_balance': initialBalance,
      if (currentBalance != null) 'current_balance': currentBalance,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (institutionName != null) 'institution_name': institutionName,
      if (accountNumberLast4 != null)
        'account_number_last4': accountNumberLast4,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? accountType,
    Value<String>? scope,
    Value<String?>? memberId,
    Value<Money>? initialBalance,
    Value<Money>? currentBalance,
    Value<String>? currencyCode,
    Value<String?>? institutionName,
    Value<String?>? accountNumberLast4,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AccountsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      accountType: accountType ?? this.accountType,
      scope: scope ?? this.scope,
      memberId: memberId ?? this.memberId,
      initialBalance: initialBalance ?? this.initialBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      currencyCode: currencyCode ?? this.currencyCode,
      institutionName: institutionName ?? this.institutionName,
      accountNumberLast4: accountNumberLast4 ?? this.accountNumberLast4,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (accountType.present) {
      map['account_type'] = Variable<String>(accountType.value);
    }
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (initialBalance.present) {
      map['initial_balance'] = Variable<int>(
        $AccountsTableTable.$converterinitialBalance.toSql(
          initialBalance.value,
        ),
      );
    }
    if (currentBalance.present) {
      map['current_balance'] = Variable<int>(
        $AccountsTableTable.$convertercurrentBalance.toSql(
          currentBalance.value,
        ),
      );
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (institutionName.present) {
      map['institution_name'] = Variable<String>(institutionName.value);
    }
    if (accountNumberLast4.present) {
      map['account_number_last4'] = Variable<String>(accountNumberLast4.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('accountType: $accountType, ')
          ..write('scope: $scope, ')
          ..write('memberId: $memberId, ')
          ..write('initialBalance: $initialBalance, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('institutionName: $institutionName, ')
          ..write('accountNumberLast4: $accountNumberLast4, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoriesTableTable extends CategoriesTable
    with TableInfo<$CategoriesTableTable, CategoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 7,
      maxTextLength: 9,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _parentIdMeta = const VerificationMeta(
    'parentId',
  );
  @override
  late final GeneratedColumn<String> parentId = GeneratedColumn<String>(
    'parent_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _isSystemMeta = const VerificationMeta(
    'isSystem',
  );
  @override
  late final GeneratedColumn<bool> isSystem = GeneratedColumn<bool>(
    'is_system',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    iconName,
    colorHex,
    type,
    scope,
    parentId,
    isSystem,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    } else if (isInserting) {
      context.missing(_iconNameMeta);
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    } else if (isInserting) {
      context.missing(_colorHexMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeMeta);
    }
    if (data.containsKey('parent_id')) {
      context.handle(
        _parentIdMeta,
        parentId.isAcceptableOrUnknown(data['parent_id']!, _parentIdMeta),
      );
    }
    if (data.containsKey('is_system')) {
      context.handle(
        _isSystemMeta,
        isSystem.isAcceptableOrUnknown(data['is_system']!, _isSystemMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      scope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope'],
      )!,
      parentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}parent_id'],
      ),
      isSystem: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CategoriesTableTable createAlias(String alias) {
    return $CategoriesTableTable(attachedDatabase, alias);
  }
}

class CategoryEntry extends DataClass implements Insertable<CategoryEntry> {
  final String id;
  final String name;
  final String iconName;
  final String colorHex;
  final String type;
  final String scope;
  final String? parentId;
  final bool isSystem;
  final DateTime createdAt;
  const CategoryEntry({
    required this.id,
    required this.name,
    required this.iconName,
    required this.colorHex,
    required this.type,
    required this.scope,
    this.parentId,
    required this.isSystem,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['icon_name'] = Variable<String>(iconName);
    map['color_hex'] = Variable<String>(colorHex);
    map['type'] = Variable<String>(type);
    map['scope'] = Variable<String>(scope);
    if (!nullToAbsent || parentId != null) {
      map['parent_id'] = Variable<String>(parentId);
    }
    map['is_system'] = Variable<bool>(isSystem);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return CategoriesTableCompanion(
      id: Value(id),
      name: Value(name),
      iconName: Value(iconName),
      colorHex: Value(colorHex),
      type: Value(type),
      scope: Value(scope),
      parentId: parentId == null && nullToAbsent
          ? const Value.absent()
          : Value(parentId),
      isSystem: Value(isSystem),
      createdAt: Value(createdAt),
    );
  }

  factory CategoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      iconName: serializer.fromJson<String>(json['iconName']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      type: serializer.fromJson<String>(json['type']),
      scope: serializer.fromJson<String>(json['scope']),
      parentId: serializer.fromJson<String?>(json['parentId']),
      isSystem: serializer.fromJson<bool>(json['isSystem']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'iconName': serializer.toJson<String>(iconName),
      'colorHex': serializer.toJson<String>(colorHex),
      'type': serializer.toJson<String>(type),
      'scope': serializer.toJson<String>(scope),
      'parentId': serializer.toJson<String?>(parentId),
      'isSystem': serializer.toJson<bool>(isSystem),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CategoryEntry copyWith({
    String? id,
    String? name,
    String? iconName,
    String? colorHex,
    String? type,
    String? scope,
    Value<String?> parentId = const Value.absent(),
    bool? isSystem,
    DateTime? createdAt,
  }) => CategoryEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    iconName: iconName ?? this.iconName,
    colorHex: colorHex ?? this.colorHex,
    type: type ?? this.type,
    scope: scope ?? this.scope,
    parentId: parentId.present ? parentId.value : this.parentId,
    isSystem: isSystem ?? this.isSystem,
    createdAt: createdAt ?? this.createdAt,
  );
  CategoryEntry copyWithCompanion(CategoriesTableCompanion data) {
    return CategoryEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      type: data.type.present ? data.type.value : this.type,
      scope: data.scope.present ? data.scope.value : this.scope,
      parentId: data.parentId.present ? data.parentId.value : this.parentId,
      isSystem: data.isSystem.present ? data.isSystem.value : this.isSystem,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('type: $type, ')
          ..write('scope: $scope, ')
          ..write('parentId: $parentId, ')
          ..write('isSystem: $isSystem, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    iconName,
    colorHex,
    type,
    scope,
    parentId,
    isSystem,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.iconName == this.iconName &&
          other.colorHex == this.colorHex &&
          other.type == this.type &&
          other.scope == this.scope &&
          other.parentId == this.parentId &&
          other.isSystem == this.isSystem &&
          other.createdAt == this.createdAt);
}

class CategoriesTableCompanion extends UpdateCompanion<CategoryEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> iconName;
  final Value<String> colorHex;
  final Value<String> type;
  final Value<String> scope;
  final Value<String?> parentId;
  final Value<bool> isSystem;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CategoriesTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.type = const Value.absent(),
    this.scope = const Value.absent(),
    this.parentId = const Value.absent(),
    this.isSystem = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesTableCompanion.insert({
    required String id,
    required String name,
    required String iconName,
    required String colorHex,
    required String type,
    required String scope,
    this.parentId = const Value.absent(),
    this.isSystem = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       iconName = Value(iconName),
       colorHex = Value(colorHex),
       type = Value(type),
       scope = Value(scope),
       createdAt = Value(createdAt);
  static Insertable<CategoryEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? iconName,
    Expression<String>? colorHex,
    Expression<String>? type,
    Expression<String>? scope,
    Expression<String>? parentId,
    Expression<bool>? isSystem,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (iconName != null) 'icon_name': iconName,
      if (colorHex != null) 'color_hex': colorHex,
      if (type != null) 'type': type,
      if (scope != null) 'scope': scope,
      if (parentId != null) 'parent_id': parentId,
      if (isSystem != null) 'is_system': isSystem,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? iconName,
    Value<String>? colorHex,
    Value<String>? type,
    Value<String>? scope,
    Value<String?>? parentId,
    Value<bool>? isSystem,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CategoriesTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      type: type ?? this.type,
      scope: scope ?? this.scope,
      parentId: parentId ?? this.parentId,
      isSystem: isSystem ?? this.isSystem,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (parentId.present) {
      map['parent_id'] = Variable<String>(parentId.value);
    }
    if (isSystem.present) {
      map['is_system'] = Variable<bool>(isSystem.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('type: $type, ')
          ..write('scope: $scope, ')
          ..write('parentId: $parentId, ')
          ..write('isSystem: $isSystem, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransfersTableTable extends TransfersTable
    with TableInfo<$TransfersTableTable, TransferEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransfersTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sourceAccountIdMeta = const VerificationMeta(
    'sourceAccountId',
  );
  @override
  late final GeneratedColumn<String> sourceAccountId = GeneratedColumn<String>(
    'source_account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _destinationAccountIdMeta =
      const VerificationMeta('destinationAccountId');
  @override
  late final GeneratedColumn<String> destinationAccountId =
      GeneratedColumn<String>(
        'destination_account_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES accounts (id) ON DELETE RESTRICT',
        ),
      );
  @override
  late final GeneratedColumnWithTypeConverter<Money, int> amount =
      GeneratedColumn<int>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Money>($TransfersTableTable.$converteramount);
  static const VerificationMeta _transferTypeMeta = const VerificationMeta(
    'transferType',
  );
  @override
  late final GeneratedColumn<String> transferType = GeneratedColumn<String>(
    'transfer_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES family_members (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _transferDateMeta = const VerificationMeta(
    'transferDate',
  );
  @override
  late final GeneratedColumn<DateTime> transferDate = GeneratedColumn<DateTime>(
    'transfer_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sourceAccountId,
    destinationAccountId,
    amount,
    transferType,
    memberId,
    transferDate,
    notes,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transfers';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransferEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('source_account_id')) {
      context.handle(
        _sourceAccountIdMeta,
        sourceAccountId.isAcceptableOrUnknown(
          data['source_account_id']!,
          _sourceAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_sourceAccountIdMeta);
    }
    if (data.containsKey('destination_account_id')) {
      context.handle(
        _destinationAccountIdMeta,
        destinationAccountId.isAcceptableOrUnknown(
          data['destination_account_id']!,
          _destinationAccountIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinationAccountIdMeta);
    }
    if (data.containsKey('transfer_type')) {
      context.handle(
        _transferTypeMeta,
        transferType.isAcceptableOrUnknown(
          data['transfer_type']!,
          _transferTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transferTypeMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('transfer_date')) {
      context.handle(
        _transferDateMeta,
        transferDate.isAcceptableOrUnknown(
          data['transfer_date']!,
          _transferDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transferDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransferEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransferEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sourceAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_account_id'],
      )!,
      destinationAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination_account_id'],
      )!,
      amount: $TransfersTableTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}amount'],
        )!,
      ),
      transferType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transfer_type'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      transferDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transfer_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TransfersTableTable createAlias(String alias) {
    return $TransfersTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Money, int> $converteramount = const MoneyConverter();
}

class TransferEntry extends DataClass implements Insertable<TransferEntry> {
  final String id;
  final String sourceAccountId;
  final String destinationAccountId;
  final Money amount;
  final String transferType;
  final String memberId;
  final DateTime transferDate;
  final String? notes;
  final DateTime createdAt;
  const TransferEntry({
    required this.id,
    required this.sourceAccountId,
    required this.destinationAccountId,
    required this.amount,
    required this.transferType,
    required this.memberId,
    required this.transferDate,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['source_account_id'] = Variable<String>(sourceAccountId);
    map['destination_account_id'] = Variable<String>(destinationAccountId);
    {
      map['amount'] = Variable<int>(
        $TransfersTableTable.$converteramount.toSql(amount),
      );
    }
    map['transfer_type'] = Variable<String>(transferType);
    map['member_id'] = Variable<String>(memberId);
    map['transfer_date'] = Variable<DateTime>(transferDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TransfersTableCompanion toCompanion(bool nullToAbsent) {
    return TransfersTableCompanion(
      id: Value(id),
      sourceAccountId: Value(sourceAccountId),
      destinationAccountId: Value(destinationAccountId),
      amount: Value(amount),
      transferType: Value(transferType),
      memberId: Value(memberId),
      transferDate: Value(transferDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory TransferEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransferEntry(
      id: serializer.fromJson<String>(json['id']),
      sourceAccountId: serializer.fromJson<String>(json['sourceAccountId']),
      destinationAccountId: serializer.fromJson<String>(
        json['destinationAccountId'],
      ),
      amount: serializer.fromJson<Money>(json['amount']),
      transferType: serializer.fromJson<String>(json['transferType']),
      memberId: serializer.fromJson<String>(json['memberId']),
      transferDate: serializer.fromJson<DateTime>(json['transferDate']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sourceAccountId': serializer.toJson<String>(sourceAccountId),
      'destinationAccountId': serializer.toJson<String>(destinationAccountId),
      'amount': serializer.toJson<Money>(amount),
      'transferType': serializer.toJson<String>(transferType),
      'memberId': serializer.toJson<String>(memberId),
      'transferDate': serializer.toJson<DateTime>(transferDate),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TransferEntry copyWith({
    String? id,
    String? sourceAccountId,
    String? destinationAccountId,
    Money? amount,
    String? transferType,
    String? memberId,
    DateTime? transferDate,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => TransferEntry(
    id: id ?? this.id,
    sourceAccountId: sourceAccountId ?? this.sourceAccountId,
    destinationAccountId: destinationAccountId ?? this.destinationAccountId,
    amount: amount ?? this.amount,
    transferType: transferType ?? this.transferType,
    memberId: memberId ?? this.memberId,
    transferDate: transferDate ?? this.transferDate,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  TransferEntry copyWithCompanion(TransfersTableCompanion data) {
    return TransferEntry(
      id: data.id.present ? data.id.value : this.id,
      sourceAccountId: data.sourceAccountId.present
          ? data.sourceAccountId.value
          : this.sourceAccountId,
      destinationAccountId: data.destinationAccountId.present
          ? data.destinationAccountId.value
          : this.destinationAccountId,
      amount: data.amount.present ? data.amount.value : this.amount,
      transferType: data.transferType.present
          ? data.transferType.value
          : this.transferType,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      transferDate: data.transferDate.present
          ? data.transferDate.value
          : this.transferDate,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransferEntry(')
          ..write('id: $id, ')
          ..write('sourceAccountId: $sourceAccountId, ')
          ..write('destinationAccountId: $destinationAccountId, ')
          ..write('amount: $amount, ')
          ..write('transferType: $transferType, ')
          ..write('memberId: $memberId, ')
          ..write('transferDate: $transferDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sourceAccountId,
    destinationAccountId,
    amount,
    transferType,
    memberId,
    transferDate,
    notes,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransferEntry &&
          other.id == this.id &&
          other.sourceAccountId == this.sourceAccountId &&
          other.destinationAccountId == this.destinationAccountId &&
          other.amount == this.amount &&
          other.transferType == this.transferType &&
          other.memberId == this.memberId &&
          other.transferDate == this.transferDate &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class TransfersTableCompanion extends UpdateCompanion<TransferEntry> {
  final Value<String> id;
  final Value<String> sourceAccountId;
  final Value<String> destinationAccountId;
  final Value<Money> amount;
  final Value<String> transferType;
  final Value<String> memberId;
  final Value<DateTime> transferDate;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TransfersTableCompanion({
    this.id = const Value.absent(),
    this.sourceAccountId = const Value.absent(),
    this.destinationAccountId = const Value.absent(),
    this.amount = const Value.absent(),
    this.transferType = const Value.absent(),
    this.memberId = const Value.absent(),
    this.transferDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransfersTableCompanion.insert({
    required String id,
    required String sourceAccountId,
    required String destinationAccountId,
    required Money amount,
    required String transferType,
    required String memberId,
    required DateTime transferDate,
    this.notes = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sourceAccountId = Value(sourceAccountId),
       destinationAccountId = Value(destinationAccountId),
       amount = Value(amount),
       transferType = Value(transferType),
       memberId = Value(memberId),
       transferDate = Value(transferDate),
       createdAt = Value(createdAt);
  static Insertable<TransferEntry> custom({
    Expression<String>? id,
    Expression<String>? sourceAccountId,
    Expression<String>? destinationAccountId,
    Expression<int>? amount,
    Expression<String>? transferType,
    Expression<String>? memberId,
    Expression<DateTime>? transferDate,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceAccountId != null) 'source_account_id': sourceAccountId,
      if (destinationAccountId != null)
        'destination_account_id': destinationAccountId,
      if (amount != null) 'amount': amount,
      if (transferType != null) 'transfer_type': transferType,
      if (memberId != null) 'member_id': memberId,
      if (transferDate != null) 'transfer_date': transferDate,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransfersTableCompanion copyWith({
    Value<String>? id,
    Value<String>? sourceAccountId,
    Value<String>? destinationAccountId,
    Value<Money>? amount,
    Value<String>? transferType,
    Value<String>? memberId,
    Value<DateTime>? transferDate,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TransfersTableCompanion(
      id: id ?? this.id,
      sourceAccountId: sourceAccountId ?? this.sourceAccountId,
      destinationAccountId: destinationAccountId ?? this.destinationAccountId,
      amount: amount ?? this.amount,
      transferType: transferType ?? this.transferType,
      memberId: memberId ?? this.memberId,
      transferDate: transferDate ?? this.transferDate,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sourceAccountId.present) {
      map['source_account_id'] = Variable<String>(sourceAccountId.value);
    }
    if (destinationAccountId.present) {
      map['destination_account_id'] = Variable<String>(
        destinationAccountId.value,
      );
    }
    if (amount.present) {
      map['amount'] = Variable<int>(
        $TransfersTableTable.$converteramount.toSql(amount.value),
      );
    }
    if (transferType.present) {
      map['transfer_type'] = Variable<String>(transferType.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (transferDate.present) {
      map['transfer_date'] = Variable<DateTime>(transferDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransfersTableCompanion(')
          ..write('id: $id, ')
          ..write('sourceAccountId: $sourceAccountId, ')
          ..write('destinationAccountId: $destinationAccountId, ')
          ..write('amount: $amount, ')
          ..write('transferType: $transferType, ')
          ..write('memberId: $memberId, ')
          ..write('transferDate: $transferDate, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTableTable extends TransactionsTable
    with TableInfo<$TransactionsTableTable, TransactionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Money, int> amount =
      GeneratedColumn<int>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Money>($TransactionsTableTable.$converteramount);
  static const VerificationMeta _transactionTypeMeta = const VerificationMeta(
    'transactionType',
  );
  @override
  late final GeneratedColumn<String> transactionType = GeneratedColumn<String>(
    'transaction_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES family_members (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _transactionDateMeta = const VerificationMeta(
    'transactionDate',
  );
  @override
  late final GeneratedColumn<DateTime> transactionDate =
      GeneratedColumn<DateTime>(
        'transaction_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _paymentMethodMeta = const VerificationMeta(
    'paymentMethod',
  );
  @override
  late final GeneratedColumn<String> paymentMethod = GeneratedColumn<String>(
    'payment_method',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hasReceiptMeta = const VerificationMeta(
    'hasReceipt',
  );
  @override
  late final GeneratedColumn<bool> hasReceipt = GeneratedColumn<bool>(
    'has_receipt',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("has_receipt" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _receiptPathMeta = const VerificationMeta(
    'receiptPath',
  );
  @override
  late final GeneratedColumn<String> receiptPath = GeneratedColumn<String>(
    'receipt_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transferIdMeta = const VerificationMeta(
    'transferId',
  );
  @override
  late final GeneratedColumn<String> transferId = GeneratedColumn<String>(
    'transfer_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES transfers (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _recurringIdMeta = const VerificationMeta(
    'recurringId',
  );
  @override
  late final GeneratedColumn<String> recurringId = GeneratedColumn<String>(
    'recurring_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    amount,
    transactionType,
    scope,
    accountId,
    categoryId,
    memberId,
    transactionDate,
    paymentMethod,
    notes,
    hasReceipt,
    receiptPath,
    transferId,
    recurringId,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transaction_type')) {
      context.handle(
        _transactionTypeMeta,
        transactionType.isAcceptableOrUnknown(
          data['transaction_type']!,
          _transactionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionTypeMeta);
    }
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('transaction_date')) {
      context.handle(
        _transactionDateMeta,
        transactionDate.isAcceptableOrUnknown(
          data['transaction_date']!,
          _transactionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionDateMeta);
    }
    if (data.containsKey('payment_method')) {
      context.handle(
        _paymentMethodMeta,
        paymentMethod.isAcceptableOrUnknown(
          data['payment_method']!,
          _paymentMethodMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentMethodMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('has_receipt')) {
      context.handle(
        _hasReceiptMeta,
        hasReceipt.isAcceptableOrUnknown(data['has_receipt']!, _hasReceiptMeta),
      );
    }
    if (data.containsKey('receipt_path')) {
      context.handle(
        _receiptPathMeta,
        receiptPath.isAcceptableOrUnknown(
          data['receipt_path']!,
          _receiptPathMeta,
        ),
      );
    }
    if (data.containsKey('transfer_id')) {
      context.handle(
        _transferIdMeta,
        transferId.isAcceptableOrUnknown(data['transfer_id']!, _transferIdMeta),
      );
    }
    if (data.containsKey('recurring_id')) {
      context.handle(
        _recurringIdMeta,
        recurringId.isAcceptableOrUnknown(
          data['recurring_id']!,
          _recurringIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      amount: $TransactionsTableTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}amount'],
        )!,
      ),
      transactionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_type'],
      )!,
      scope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      transactionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}transaction_date'],
      )!,
      paymentMethod: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_method'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      hasReceipt: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}has_receipt'],
      )!,
      receiptPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}receipt_path'],
      ),
      transferId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transfer_id'],
      ),
      recurringId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurring_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TransactionsTableTable createAlias(String alias) {
    return $TransactionsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Money, int> $converteramount = const MoneyConverter();
}

class TransactionEntry extends DataClass
    implements Insertable<TransactionEntry> {
  final String id;
  final Money amount;
  final String transactionType;
  final String scope;
  final String accountId;
  final String? categoryId;
  final String memberId;
  final DateTime transactionDate;
  final String paymentMethod;
  final String? notes;
  final bool hasReceipt;
  final String? receiptPath;
  final String? transferId;
  final String? recurringId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TransactionEntry({
    required this.id,
    required this.amount,
    required this.transactionType,
    required this.scope,
    required this.accountId,
    this.categoryId,
    required this.memberId,
    required this.transactionDate,
    required this.paymentMethod,
    this.notes,
    required this.hasReceipt,
    this.receiptPath,
    this.transferId,
    this.recurringId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    {
      map['amount'] = Variable<int>(
        $TransactionsTableTable.$converteramount.toSql(amount),
      );
    }
    map['transaction_type'] = Variable<String>(transactionType);
    map['scope'] = Variable<String>(scope);
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['member_id'] = Variable<String>(memberId);
    map['transaction_date'] = Variable<DateTime>(transactionDate);
    map['payment_method'] = Variable<String>(paymentMethod);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['has_receipt'] = Variable<bool>(hasReceipt);
    if (!nullToAbsent || receiptPath != null) {
      map['receipt_path'] = Variable<String>(receiptPath);
    }
    if (!nullToAbsent || transferId != null) {
      map['transfer_id'] = Variable<String>(transferId);
    }
    if (!nullToAbsent || recurringId != null) {
      map['recurring_id'] = Variable<String>(recurringId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TransactionsTableCompanion toCompanion(bool nullToAbsent) {
    return TransactionsTableCompanion(
      id: Value(id),
      amount: Value(amount),
      transactionType: Value(transactionType),
      scope: Value(scope),
      accountId: Value(accountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      memberId: Value(memberId),
      transactionDate: Value(transactionDate),
      paymentMethod: Value(paymentMethod),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      hasReceipt: Value(hasReceipt),
      receiptPath: receiptPath == null && nullToAbsent
          ? const Value.absent()
          : Value(receiptPath),
      transferId: transferId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferId),
      recurringId: recurringId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TransactionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionEntry(
      id: serializer.fromJson<String>(json['id']),
      amount: serializer.fromJson<Money>(json['amount']),
      transactionType: serializer.fromJson<String>(json['transactionType']),
      scope: serializer.fromJson<String>(json['scope']),
      accountId: serializer.fromJson<String>(json['accountId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      memberId: serializer.fromJson<String>(json['memberId']),
      transactionDate: serializer.fromJson<DateTime>(json['transactionDate']),
      paymentMethod: serializer.fromJson<String>(json['paymentMethod']),
      notes: serializer.fromJson<String?>(json['notes']),
      hasReceipt: serializer.fromJson<bool>(json['hasReceipt']),
      receiptPath: serializer.fromJson<String?>(json['receiptPath']),
      transferId: serializer.fromJson<String?>(json['transferId']),
      recurringId: serializer.fromJson<String?>(json['recurringId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'amount': serializer.toJson<Money>(amount),
      'transactionType': serializer.toJson<String>(transactionType),
      'scope': serializer.toJson<String>(scope),
      'accountId': serializer.toJson<String>(accountId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'memberId': serializer.toJson<String>(memberId),
      'transactionDate': serializer.toJson<DateTime>(transactionDate),
      'paymentMethod': serializer.toJson<String>(paymentMethod),
      'notes': serializer.toJson<String?>(notes),
      'hasReceipt': serializer.toJson<bool>(hasReceipt),
      'receiptPath': serializer.toJson<String?>(receiptPath),
      'transferId': serializer.toJson<String?>(transferId),
      'recurringId': serializer.toJson<String?>(recurringId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TransactionEntry copyWith({
    String? id,
    Money? amount,
    String? transactionType,
    String? scope,
    String? accountId,
    Value<String?> categoryId = const Value.absent(),
    String? memberId,
    DateTime? transactionDate,
    String? paymentMethod,
    Value<String?> notes = const Value.absent(),
    bool? hasReceipt,
    Value<String?> receiptPath = const Value.absent(),
    Value<String?> transferId = const Value.absent(),
    Value<String?> recurringId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TransactionEntry(
    id: id ?? this.id,
    amount: amount ?? this.amount,
    transactionType: transactionType ?? this.transactionType,
    scope: scope ?? this.scope,
    accountId: accountId ?? this.accountId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    memberId: memberId ?? this.memberId,
    transactionDate: transactionDate ?? this.transactionDate,
    paymentMethod: paymentMethod ?? this.paymentMethod,
    notes: notes.present ? notes.value : this.notes,
    hasReceipt: hasReceipt ?? this.hasReceipt,
    receiptPath: receiptPath.present ? receiptPath.value : this.receiptPath,
    transferId: transferId.present ? transferId.value : this.transferId,
    recurringId: recurringId.present ? recurringId.value : this.recurringId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TransactionEntry copyWithCompanion(TransactionsTableCompanion data) {
    return TransactionEntry(
      id: data.id.present ? data.id.value : this.id,
      amount: data.amount.present ? data.amount.value : this.amount,
      transactionType: data.transactionType.present
          ? data.transactionType.value
          : this.transactionType,
      scope: data.scope.present ? data.scope.value : this.scope,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      transactionDate: data.transactionDate.present
          ? data.transactionDate.value
          : this.transactionDate,
      paymentMethod: data.paymentMethod.present
          ? data.paymentMethod.value
          : this.paymentMethod,
      notes: data.notes.present ? data.notes.value : this.notes,
      hasReceipt: data.hasReceipt.present
          ? data.hasReceipt.value
          : this.hasReceipt,
      receiptPath: data.receiptPath.present
          ? data.receiptPath.value
          : this.receiptPath,
      transferId: data.transferId.present
          ? data.transferId.value
          : this.transferId,
      recurringId: data.recurringId.present
          ? data.recurringId.value
          : this.recurringId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionEntry(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('transactionType: $transactionType, ')
          ..write('scope: $scope, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('memberId: $memberId, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('notes: $notes, ')
          ..write('hasReceipt: $hasReceipt, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('transferId: $transferId, ')
          ..write('recurringId: $recurringId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    amount,
    transactionType,
    scope,
    accountId,
    categoryId,
    memberId,
    transactionDate,
    paymentMethod,
    notes,
    hasReceipt,
    receiptPath,
    transferId,
    recurringId,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionEntry &&
          other.id == this.id &&
          other.amount == this.amount &&
          other.transactionType == this.transactionType &&
          other.scope == this.scope &&
          other.accountId == this.accountId &&
          other.categoryId == this.categoryId &&
          other.memberId == this.memberId &&
          other.transactionDate == this.transactionDate &&
          other.paymentMethod == this.paymentMethod &&
          other.notes == this.notes &&
          other.hasReceipt == this.hasReceipt &&
          other.receiptPath == this.receiptPath &&
          other.transferId == this.transferId &&
          other.recurringId == this.recurringId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TransactionsTableCompanion extends UpdateCompanion<TransactionEntry> {
  final Value<String> id;
  final Value<Money> amount;
  final Value<String> transactionType;
  final Value<String> scope;
  final Value<String> accountId;
  final Value<String?> categoryId;
  final Value<String> memberId;
  final Value<DateTime> transactionDate;
  final Value<String> paymentMethod;
  final Value<String?> notes;
  final Value<bool> hasReceipt;
  final Value<String?> receiptPath;
  final Value<String?> transferId;
  final Value<String?> recurringId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TransactionsTableCompanion({
    this.id = const Value.absent(),
    this.amount = const Value.absent(),
    this.transactionType = const Value.absent(),
    this.scope = const Value.absent(),
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.transactionDate = const Value.absent(),
    this.paymentMethod = const Value.absent(),
    this.notes = const Value.absent(),
    this.hasReceipt = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.transferId = const Value.absent(),
    this.recurringId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsTableCompanion.insert({
    required String id,
    required Money amount,
    required String transactionType,
    required String scope,
    required String accountId,
    this.categoryId = const Value.absent(),
    required String memberId,
    required DateTime transactionDate,
    required String paymentMethod,
    this.notes = const Value.absent(),
    this.hasReceipt = const Value.absent(),
    this.receiptPath = const Value.absent(),
    this.transferId = const Value.absent(),
    this.recurringId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       amount = Value(amount),
       transactionType = Value(transactionType),
       scope = Value(scope),
       accountId = Value(accountId),
       memberId = Value(memberId),
       transactionDate = Value(transactionDate),
       paymentMethod = Value(paymentMethod),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<TransactionEntry> custom({
    Expression<String>? id,
    Expression<int>? amount,
    Expression<String>? transactionType,
    Expression<String>? scope,
    Expression<String>? accountId,
    Expression<String>? categoryId,
    Expression<String>? memberId,
    Expression<DateTime>? transactionDate,
    Expression<String>? paymentMethod,
    Expression<String>? notes,
    Expression<bool>? hasReceipt,
    Expression<String>? receiptPath,
    Expression<String>? transferId,
    Expression<String>? recurringId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (amount != null) 'amount': amount,
      if (transactionType != null) 'transaction_type': transactionType,
      if (scope != null) 'scope': scope,
      if (accountId != null) 'account_id': accountId,
      if (categoryId != null) 'category_id': categoryId,
      if (memberId != null) 'member_id': memberId,
      if (transactionDate != null) 'transaction_date': transactionDate,
      if (paymentMethod != null) 'payment_method': paymentMethod,
      if (notes != null) 'notes': notes,
      if (hasReceipt != null) 'has_receipt': hasReceipt,
      if (receiptPath != null) 'receipt_path': receiptPath,
      if (transferId != null) 'transfer_id': transferId,
      if (recurringId != null) 'recurring_id': recurringId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsTableCompanion copyWith({
    Value<String>? id,
    Value<Money>? amount,
    Value<String>? transactionType,
    Value<String>? scope,
    Value<String>? accountId,
    Value<String?>? categoryId,
    Value<String>? memberId,
    Value<DateTime>? transactionDate,
    Value<String>? paymentMethod,
    Value<String?>? notes,
    Value<bool>? hasReceipt,
    Value<String?>? receiptPath,
    Value<String?>? transferId,
    Value<String?>? recurringId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TransactionsTableCompanion(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      transactionType: transactionType ?? this.transactionType,
      scope: scope ?? this.scope,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      memberId: memberId ?? this.memberId,
      transactionDate: transactionDate ?? this.transactionDate,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      notes: notes ?? this.notes,
      hasReceipt: hasReceipt ?? this.hasReceipt,
      receiptPath: receiptPath ?? this.receiptPath,
      transferId: transferId ?? this.transferId,
      recurringId: recurringId ?? this.recurringId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(
        $TransactionsTableTable.$converteramount.toSql(amount.value),
      );
    }
    if (transactionType.present) {
      map['transaction_type'] = Variable<String>(transactionType.value);
    }
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (transactionDate.present) {
      map['transaction_date'] = Variable<DateTime>(transactionDate.value);
    }
    if (paymentMethod.present) {
      map['payment_method'] = Variable<String>(paymentMethod.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (hasReceipt.present) {
      map['has_receipt'] = Variable<bool>(hasReceipt.value);
    }
    if (receiptPath.present) {
      map['receipt_path'] = Variable<String>(receiptPath.value);
    }
    if (transferId.present) {
      map['transfer_id'] = Variable<String>(transferId.value);
    }
    if (recurringId.present) {
      map['recurring_id'] = Variable<String>(recurringId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsTableCompanion(')
          ..write('id: $id, ')
          ..write('amount: $amount, ')
          ..write('transactionType: $transactionType, ')
          ..write('scope: $scope, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('memberId: $memberId, ')
          ..write('transactionDate: $transactionDate, ')
          ..write('paymentMethod: $paymentMethod, ')
          ..write('notes: $notes, ')
          ..write('hasReceipt: $hasReceipt, ')
          ..write('receiptPath: $receiptPath, ')
          ..write('transferId: $transferId, ')
          ..write('recurringId: $recurringId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTableTable extends BudgetsTable
    with TableInfo<$BudgetsTableTable, BudgetEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES family_members (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _monthMeta = const VerificationMeta('month');
  @override
  late final GeneratedColumn<int> month = GeneratedColumn<int>(
    'month',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _yearMeta = const VerificationMeta('year');
  @override
  late final GeneratedColumn<int> year = GeneratedColumn<int>(
    'year',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Money, int> totalLimit =
      GeneratedColumn<int>(
        'total_limit',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Money>($BudgetsTableTable.$convertertotalLimit);
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    scope,
    memberId,
    month,
    year,
    totalLimit,
    isActive,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    }
    if (data.containsKey('month')) {
      context.handle(
        _monthMeta,
        month.isAcceptableOrUnknown(data['month']!, _monthMeta),
      );
    } else if (isInserting) {
      context.missing(_monthMeta);
    }
    if (data.containsKey('year')) {
      context.handle(
        _yearMeta,
        year.isAcceptableOrUnknown(data['year']!, _yearMeta),
      );
    } else if (isInserting) {
      context.missing(_yearMeta);
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {scope, memberId, month, year},
  ];
  @override
  BudgetEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      scope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      ),
      month: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}month'],
      )!,
      year: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}year'],
      )!,
      totalLimit: $BudgetsTableTable.$convertertotalLimit.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}total_limit'],
        )!,
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BudgetsTableTable createAlias(String alias) {
    return $BudgetsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Money, int> $convertertotalLimit =
      const MoneyConverter();
}

class BudgetEntry extends DataClass implements Insertable<BudgetEntry> {
  final String id;
  final String name;
  final String scope;
  final String? memberId;
  final int month;
  final int year;
  final Money totalLimit;
  final bool isActive;
  final DateTime createdAt;
  const BudgetEntry({
    required this.id,
    required this.name,
    required this.scope,
    this.memberId,
    required this.month,
    required this.year,
    required this.totalLimit,
    required this.isActive,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['scope'] = Variable<String>(scope);
    if (!nullToAbsent || memberId != null) {
      map['member_id'] = Variable<String>(memberId);
    }
    map['month'] = Variable<int>(month);
    map['year'] = Variable<int>(year);
    {
      map['total_limit'] = Variable<int>(
        $BudgetsTableTable.$convertertotalLimit.toSql(totalLimit),
      );
    }
    map['is_active'] = Variable<bool>(isActive);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BudgetsTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetsTableCompanion(
      id: Value(id),
      name: Value(name),
      scope: Value(scope),
      memberId: memberId == null && nullToAbsent
          ? const Value.absent()
          : Value(memberId),
      month: Value(month),
      year: Value(year),
      totalLimit: Value(totalLimit),
      isActive: Value(isActive),
      createdAt: Value(createdAt),
    );
  }

  factory BudgetEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      scope: serializer.fromJson<String>(json['scope']),
      memberId: serializer.fromJson<String?>(json['memberId']),
      month: serializer.fromJson<int>(json['month']),
      year: serializer.fromJson<int>(json['year']),
      totalLimit: serializer.fromJson<Money>(json['totalLimit']),
      isActive: serializer.fromJson<bool>(json['isActive']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'scope': serializer.toJson<String>(scope),
      'memberId': serializer.toJson<String?>(memberId),
      'month': serializer.toJson<int>(month),
      'year': serializer.toJson<int>(year),
      'totalLimit': serializer.toJson<Money>(totalLimit),
      'isActive': serializer.toJson<bool>(isActive),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BudgetEntry copyWith({
    String? id,
    String? name,
    String? scope,
    Value<String?> memberId = const Value.absent(),
    int? month,
    int? year,
    Money? totalLimit,
    bool? isActive,
    DateTime? createdAt,
  }) => BudgetEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    scope: scope ?? this.scope,
    memberId: memberId.present ? memberId.value : this.memberId,
    month: month ?? this.month,
    year: year ?? this.year,
    totalLimit: totalLimit ?? this.totalLimit,
    isActive: isActive ?? this.isActive,
    createdAt: createdAt ?? this.createdAt,
  );
  BudgetEntry copyWithCompanion(BudgetsTableCompanion data) {
    return BudgetEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      scope: data.scope.present ? data.scope.value : this.scope,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      month: data.month.present ? data.month.value : this.month,
      year: data.year.present ? data.year.value : this.year,
      totalLimit: data.totalLimit.present
          ? data.totalLimit.value
          : this.totalLimit,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('scope: $scope, ')
          ..write('memberId: $memberId, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('totalLimit: $totalLimit, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    scope,
    memberId,
    month,
    year,
    totalLimit,
    isActive,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.scope == this.scope &&
          other.memberId == this.memberId &&
          other.month == this.month &&
          other.year == this.year &&
          other.totalLimit == this.totalLimit &&
          other.isActive == this.isActive &&
          other.createdAt == this.createdAt);
}

class BudgetsTableCompanion extends UpdateCompanion<BudgetEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> scope;
  final Value<String?> memberId;
  final Value<int> month;
  final Value<int> year;
  final Value<Money> totalLimit;
  final Value<bool> isActive;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BudgetsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.scope = const Value.absent(),
    this.memberId = const Value.absent(),
    this.month = const Value.absent(),
    this.year = const Value.absent(),
    this.totalLimit = const Value.absent(),
    this.isActive = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsTableCompanion.insert({
    required String id,
    required String name,
    required String scope,
    this.memberId = const Value.absent(),
    required int month,
    required int year,
    required Money totalLimit,
    this.isActive = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       scope = Value(scope),
       month = Value(month),
       year = Value(year),
       totalLimit = Value(totalLimit),
       createdAt = Value(createdAt);
  static Insertable<BudgetEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? scope,
    Expression<String>? memberId,
    Expression<int>? month,
    Expression<int>? year,
    Expression<int>? totalLimit,
    Expression<bool>? isActive,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (scope != null) 'scope': scope,
      if (memberId != null) 'member_id': memberId,
      if (month != null) 'month': month,
      if (year != null) 'year': year,
      if (totalLimit != null) 'total_limit': totalLimit,
      if (isActive != null) 'is_active': isActive,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? scope,
    Value<String?>? memberId,
    Value<int>? month,
    Value<int>? year,
    Value<Money>? totalLimit,
    Value<bool>? isActive,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BudgetsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      scope: scope ?? this.scope,
      memberId: memberId ?? this.memberId,
      month: month ?? this.month,
      year: year ?? this.year,
      totalLimit: totalLimit ?? this.totalLimit,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (month.present) {
      map['month'] = Variable<int>(month.value);
    }
    if (year.present) {
      map['year'] = Variable<int>(year.value);
    }
    if (totalLimit.present) {
      map['total_limit'] = Variable<int>(
        $BudgetsTableTable.$convertertotalLimit.toSql(totalLimit.value),
      );
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('scope: $scope, ')
          ..write('memberId: $memberId, ')
          ..write('month: $month, ')
          ..write('year: $year, ')
          ..write('totalLimit: $totalLimit, ')
          ..write('isActive: $isActive, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetCategoriesTableTable extends BudgetCategoriesTable
    with TableInfo<$BudgetCategoriesTableTable, BudgetCategoryEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetCategoriesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES budgets (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Money, int> allocatedLimit =
      GeneratedColumn<int>(
        'allocated_limit',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Money>(
        $BudgetCategoriesTableTable.$converterallocatedLimit,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    budgetId,
    categoryId,
    allocatedLimit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetCategoryEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {budgetId, categoryId},
  ];
  @override
  BudgetCategoryEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetCategoryEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      allocatedLimit: $BudgetCategoriesTableTable.$converterallocatedLimit
          .fromSql(
            attachedDatabase.typeMapping.read(
              DriftSqlType.int,
              data['${effectivePrefix}allocated_limit'],
            )!,
          ),
    );
  }

  @override
  $BudgetCategoriesTableTable createAlias(String alias) {
    return $BudgetCategoriesTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Money, int> $converterallocatedLimit =
      const MoneyConverter();
}

class BudgetCategoryEntry extends DataClass
    implements Insertable<BudgetCategoryEntry> {
  final String id;
  final String budgetId;
  final String categoryId;
  final Money allocatedLimit;
  const BudgetCategoryEntry({
    required this.id,
    required this.budgetId,
    required this.categoryId,
    required this.allocatedLimit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['budget_id'] = Variable<String>(budgetId);
    map['category_id'] = Variable<String>(categoryId);
    {
      map['allocated_limit'] = Variable<int>(
        $BudgetCategoriesTableTable.$converterallocatedLimit.toSql(
          allocatedLimit,
        ),
      );
    }
    return map;
  }

  BudgetCategoriesTableCompanion toCompanion(bool nullToAbsent) {
    return BudgetCategoriesTableCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      categoryId: Value(categoryId),
      allocatedLimit: Value(allocatedLimit),
    );
  }

  factory BudgetCategoryEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetCategoryEntry(
      id: serializer.fromJson<String>(json['id']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      allocatedLimit: serializer.fromJson<Money>(json['allocatedLimit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'budgetId': serializer.toJson<String>(budgetId),
      'categoryId': serializer.toJson<String>(categoryId),
      'allocatedLimit': serializer.toJson<Money>(allocatedLimit),
    };
  }

  BudgetCategoryEntry copyWith({
    String? id,
    String? budgetId,
    String? categoryId,
    Money? allocatedLimit,
  }) => BudgetCategoryEntry(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    categoryId: categoryId ?? this.categoryId,
    allocatedLimit: allocatedLimit ?? this.allocatedLimit,
  );
  BudgetCategoryEntry copyWithCompanion(BudgetCategoriesTableCompanion data) {
    return BudgetCategoryEntry(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      allocatedLimit: data.allocatedLimit.present
          ? data.allocatedLimit.value
          : this.allocatedLimit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCategoryEntry(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('categoryId: $categoryId, ')
          ..write('allocatedLimit: $allocatedLimit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, budgetId, categoryId, allocatedLimit);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetCategoryEntry &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.categoryId == this.categoryId &&
          other.allocatedLimit == this.allocatedLimit);
}

class BudgetCategoriesTableCompanion
    extends UpdateCompanion<BudgetCategoryEntry> {
  final Value<String> id;
  final Value<String> budgetId;
  final Value<String> categoryId;
  final Value<Money> allocatedLimit;
  final Value<int> rowid;
  const BudgetCategoriesTableCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.allocatedLimit = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetCategoriesTableCompanion.insert({
    required String id,
    required String budgetId,
    required String categoryId,
    required Money allocatedLimit,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       budgetId = Value(budgetId),
       categoryId = Value(categoryId),
       allocatedLimit = Value(allocatedLimit);
  static Insertable<BudgetCategoryEntry> custom({
    Expression<String>? id,
    Expression<String>? budgetId,
    Expression<String>? categoryId,
    Expression<int>? allocatedLimit,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (categoryId != null) 'category_id': categoryId,
      if (allocatedLimit != null) 'allocated_limit': allocatedLimit,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetCategoriesTableCompanion copyWith({
    Value<String>? id,
    Value<String>? budgetId,
    Value<String>? categoryId,
    Value<Money>? allocatedLimit,
    Value<int>? rowid,
  }) {
    return BudgetCategoriesTableCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      categoryId: categoryId ?? this.categoryId,
      allocatedLimit: allocatedLimit ?? this.allocatedLimit,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (allocatedLimit.present) {
      map['allocated_limit'] = Variable<int>(
        $BudgetCategoriesTableTable.$converterallocatedLimit.toSql(
          allocatedLimit.value,
        ),
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetCategoriesTableCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('categoryId: $categoryId, ')
          ..write('allocatedLimit: $allocatedLimit, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SavingsGoalsTableTable extends SavingsGoalsTable
    with TableInfo<$SavingsGoalsTableTable, SavingsGoalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SavingsGoalsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES family_members (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Money, int> targetAmount =
      GeneratedColumn<int>(
        'target_amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Money>($SavingsGoalsTableTable.$convertertargetAmount);
  @override
  late final GeneratedColumnWithTypeConverter<Money, int> currentAmount =
      GeneratedColumn<int>(
        'current_amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Money>($SavingsGoalsTableTable.$convertercurrentAmount);
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _iconNameMeta = const VerificationMeta(
    'iconName',
  );
  @override
  late final GeneratedColumn<String> iconName = GeneratedColumn<String>(
    'icon_name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('savings'),
  );
  static const VerificationMeta _colorHexMeta = const VerificationMeta(
    'colorHex',
  );
  @override
  late final GeneratedColumn<String> colorHex = GeneratedColumn<String>(
    'color_hex',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 7,
      maxTextLength: 9,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('#16A34A'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('inProgress'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    scope,
    memberId,
    targetAmount,
    currentAmount,
    targetDate,
    iconName,
    colorHex,
    status,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'savings_goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<SavingsGoalEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('icon_name')) {
      context.handle(
        _iconNameMeta,
        iconName.isAcceptableOrUnknown(data['icon_name']!, _iconNameMeta),
      );
    }
    if (data.containsKey('color_hex')) {
      context.handle(
        _colorHexMeta,
        colorHex.isAcceptableOrUnknown(data['color_hex']!, _colorHexMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SavingsGoalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SavingsGoalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      scope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      ),
      targetAmount: $SavingsGoalsTableTable.$convertertargetAmount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}target_amount'],
        )!,
      ),
      currentAmount: $SavingsGoalsTableTable.$convertercurrentAmount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}current_amount'],
        )!,
      ),
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      ),
      iconName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}icon_name'],
      )!,
      colorHex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color_hex'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SavingsGoalsTableTable createAlias(String alias) {
    return $SavingsGoalsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Money, int> $convertertargetAmount =
      const MoneyConverter();
  static TypeConverter<Money, int> $convertercurrentAmount =
      const MoneyConverter();
}

class SavingsGoalEntry extends DataClass
    implements Insertable<SavingsGoalEntry> {
  final String id;
  final String name;
  final String scope;
  final String? memberId;
  final Money targetAmount;
  final Money currentAmount;
  final DateTime? targetDate;
  final String iconName;
  final String colorHex;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  const SavingsGoalEntry({
    required this.id,
    required this.name,
    required this.scope,
    this.memberId,
    required this.targetAmount,
    required this.currentAmount,
    this.targetDate,
    required this.iconName,
    required this.colorHex,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['scope'] = Variable<String>(scope);
    if (!nullToAbsent || memberId != null) {
      map['member_id'] = Variable<String>(memberId);
    }
    {
      map['target_amount'] = Variable<int>(
        $SavingsGoalsTableTable.$convertertargetAmount.toSql(targetAmount),
      );
    }
    {
      map['current_amount'] = Variable<int>(
        $SavingsGoalsTableTable.$convertercurrentAmount.toSql(currentAmount),
      );
    }
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    map['icon_name'] = Variable<String>(iconName);
    map['color_hex'] = Variable<String>(colorHex);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SavingsGoalsTableCompanion toCompanion(bool nullToAbsent) {
    return SavingsGoalsTableCompanion(
      id: Value(id),
      name: Value(name),
      scope: Value(scope),
      memberId: memberId == null && nullToAbsent
          ? const Value.absent()
          : Value(memberId),
      targetAmount: Value(targetAmount),
      currentAmount: Value(currentAmount),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      iconName: Value(iconName),
      colorHex: Value(colorHex),
      status: Value(status),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SavingsGoalEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SavingsGoalEntry(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      scope: serializer.fromJson<String>(json['scope']),
      memberId: serializer.fromJson<String?>(json['memberId']),
      targetAmount: serializer.fromJson<Money>(json['targetAmount']),
      currentAmount: serializer.fromJson<Money>(json['currentAmount']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      iconName: serializer.fromJson<String>(json['iconName']),
      colorHex: serializer.fromJson<String>(json['colorHex']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'scope': serializer.toJson<String>(scope),
      'memberId': serializer.toJson<String?>(memberId),
      'targetAmount': serializer.toJson<Money>(targetAmount),
      'currentAmount': serializer.toJson<Money>(currentAmount),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'iconName': serializer.toJson<String>(iconName),
      'colorHex': serializer.toJson<String>(colorHex),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SavingsGoalEntry copyWith({
    String? id,
    String? name,
    String? scope,
    Value<String?> memberId = const Value.absent(),
    Money? targetAmount,
    Money? currentAmount,
    Value<DateTime?> targetDate = const Value.absent(),
    String? iconName,
    String? colorHex,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => SavingsGoalEntry(
    id: id ?? this.id,
    name: name ?? this.name,
    scope: scope ?? this.scope,
    memberId: memberId.present ? memberId.value : this.memberId,
    targetAmount: targetAmount ?? this.targetAmount,
    currentAmount: currentAmount ?? this.currentAmount,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    iconName: iconName ?? this.iconName,
    colorHex: colorHex ?? this.colorHex,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SavingsGoalEntry copyWithCompanion(SavingsGoalsTableCompanion data) {
    return SavingsGoalEntry(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      scope: data.scope.present ? data.scope.value : this.scope,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      currentAmount: data.currentAmount.present
          ? data.currentAmount.value
          : this.currentAmount,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      iconName: data.iconName.present ? data.iconName.value : this.iconName,
      colorHex: data.colorHex.present ? data.colorHex.value : this.colorHex,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalEntry(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('scope: $scope, ')
          ..write('memberId: $memberId, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    scope,
    memberId,
    targetAmount,
    currentAmount,
    targetDate,
    iconName,
    colorHex,
    status,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SavingsGoalEntry &&
          other.id == this.id &&
          other.name == this.name &&
          other.scope == this.scope &&
          other.memberId == this.memberId &&
          other.targetAmount == this.targetAmount &&
          other.currentAmount == this.currentAmount &&
          other.targetDate == this.targetDate &&
          other.iconName == this.iconName &&
          other.colorHex == this.colorHex &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class SavingsGoalsTableCompanion extends UpdateCompanion<SavingsGoalEntry> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> scope;
  final Value<String?> memberId;
  final Value<Money> targetAmount;
  final Value<Money> currentAmount;
  final Value<DateTime?> targetDate;
  final Value<String> iconName;
  final Value<String> colorHex;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SavingsGoalsTableCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.scope = const Value.absent(),
    this.memberId = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.currentAmount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SavingsGoalsTableCompanion.insert({
    required String id,
    required String name,
    required String scope,
    this.memberId = const Value.absent(),
    required Money targetAmount,
    required Money currentAmount,
    this.targetDate = const Value.absent(),
    this.iconName = const Value.absent(),
    this.colorHex = const Value.absent(),
    this.status = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       scope = Value(scope),
       targetAmount = Value(targetAmount),
       currentAmount = Value(currentAmount),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<SavingsGoalEntry> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? scope,
    Expression<String>? memberId,
    Expression<int>? targetAmount,
    Expression<int>? currentAmount,
    Expression<DateTime>? targetDate,
    Expression<String>? iconName,
    Expression<String>? colorHex,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (scope != null) 'scope': scope,
      if (memberId != null) 'member_id': memberId,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (currentAmount != null) 'current_amount': currentAmount,
      if (targetDate != null) 'target_date': targetDate,
      if (iconName != null) 'icon_name': iconName,
      if (colorHex != null) 'color_hex': colorHex,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SavingsGoalsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? scope,
    Value<String?>? memberId,
    Value<Money>? targetAmount,
    Value<Money>? currentAmount,
    Value<DateTime?>? targetDate,
    Value<String>? iconName,
    Value<String>? colorHex,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SavingsGoalsTableCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      scope: scope ?? this.scope,
      memberId: memberId ?? this.memberId,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      targetDate: targetDate ?? this.targetDate,
      iconName: iconName ?? this.iconName,
      colorHex: colorHex ?? this.colorHex,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<int>(
        $SavingsGoalsTableTable.$convertertargetAmount.toSql(
          targetAmount.value,
        ),
      );
    }
    if (currentAmount.present) {
      map['current_amount'] = Variable<int>(
        $SavingsGoalsTableTable.$convertercurrentAmount.toSql(
          currentAmount.value,
        ),
      );
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (iconName.present) {
      map['icon_name'] = Variable<String>(iconName.value);
    }
    if (colorHex.present) {
      map['color_hex'] = Variable<String>(colorHex.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SavingsGoalsTableCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('scope: $scope, ')
          ..write('memberId: $memberId, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('iconName: $iconName, ')
          ..write('colorHex: $colorHex, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalContributionsTableTable extends GoalContributionsTable
    with TableInfo<$GoalContributionsTableTable, GoalContributionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalContributionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES savings_goals (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES family_members (id) ON DELETE RESTRICT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<Money, int> amount =
      GeneratedColumn<int>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Money>($GoalContributionsTableTable.$converteramount);
  static const VerificationMeta _contributionDateMeta = const VerificationMeta(
    'contributionDate',
  );
  @override
  late final GeneratedColumn<DateTime> contributionDate =
      GeneratedColumn<DateTime>(
        'contribution_date',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalId,
    accountId,
    memberId,
    amount,
    contributionDate,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal_contributions';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalContributionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('contribution_date')) {
      context.handle(
        _contributionDateMeta,
        contributionDate.isAcceptableOrUnknown(
          data['contribution_date']!,
          _contributionDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contributionDateMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalContributionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalContributionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      amount: $GoalContributionsTableTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}amount'],
        )!,
      ),
      contributionDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}contribution_date'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $GoalContributionsTableTable createAlias(String alias) {
    return $GoalContributionsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Money, int> $converteramount = const MoneyConverter();
}

class GoalContributionEntry extends DataClass
    implements Insertable<GoalContributionEntry> {
  final String id;
  final String goalId;
  final String accountId;
  final String memberId;
  final Money amount;
  final DateTime contributionDate;
  final String? notes;
  const GoalContributionEntry({
    required this.id,
    required this.goalId,
    required this.accountId,
    required this.memberId,
    required this.amount,
    required this.contributionDate,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_id'] = Variable<String>(goalId);
    map['account_id'] = Variable<String>(accountId);
    map['member_id'] = Variable<String>(memberId);
    {
      map['amount'] = Variable<int>(
        $GoalContributionsTableTable.$converteramount.toSql(amount),
      );
    }
    map['contribution_date'] = Variable<DateTime>(contributionDate);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  GoalContributionsTableCompanion toCompanion(bool nullToAbsent) {
    return GoalContributionsTableCompanion(
      id: Value(id),
      goalId: Value(goalId),
      accountId: Value(accountId),
      memberId: Value(memberId),
      amount: Value(amount),
      contributionDate: Value(contributionDate),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory GoalContributionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalContributionEntry(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String>(json['goalId']),
      accountId: serializer.fromJson<String>(json['accountId']),
      memberId: serializer.fromJson<String>(json['memberId']),
      amount: serializer.fromJson<Money>(json['amount']),
      contributionDate: serializer.fromJson<DateTime>(json['contributionDate']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String>(goalId),
      'accountId': serializer.toJson<String>(accountId),
      'memberId': serializer.toJson<String>(memberId),
      'amount': serializer.toJson<Money>(amount),
      'contributionDate': serializer.toJson<DateTime>(contributionDate),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  GoalContributionEntry copyWith({
    String? id,
    String? goalId,
    String? accountId,
    String? memberId,
    Money? amount,
    DateTime? contributionDate,
    Value<String?> notes = const Value.absent(),
  }) => GoalContributionEntry(
    id: id ?? this.id,
    goalId: goalId ?? this.goalId,
    accountId: accountId ?? this.accountId,
    memberId: memberId ?? this.memberId,
    amount: amount ?? this.amount,
    contributionDate: contributionDate ?? this.contributionDate,
    notes: notes.present ? notes.value : this.notes,
  );
  GoalContributionEntry copyWithCompanion(
    GoalContributionsTableCompanion data,
  ) {
    return GoalContributionEntry(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      amount: data.amount.present ? data.amount.value : this.amount,
      contributionDate: data.contributionDate.present
          ? data.contributionDate.value
          : this.contributionDate,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalContributionEntry(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('accountId: $accountId, ')
          ..write('memberId: $memberId, ')
          ..write('amount: $amount, ')
          ..write('contributionDate: $contributionDate, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    goalId,
    accountId,
    memberId,
    amount,
    contributionDate,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalContributionEntry &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.accountId == this.accountId &&
          other.memberId == this.memberId &&
          other.amount == this.amount &&
          other.contributionDate == this.contributionDate &&
          other.notes == this.notes);
}

class GoalContributionsTableCompanion
    extends UpdateCompanion<GoalContributionEntry> {
  final Value<String> id;
  final Value<String> goalId;
  final Value<String> accountId;
  final Value<String> memberId;
  final Value<Money> amount;
  final Value<DateTime> contributionDate;
  final Value<String?> notes;
  final Value<int> rowid;
  const GoalContributionsTableCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.amount = const Value.absent(),
    this.contributionDate = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalContributionsTableCompanion.insert({
    required String id,
    required String goalId,
    required String accountId,
    required String memberId,
    required Money amount,
    required DateTime contributionDate,
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       goalId = Value(goalId),
       accountId = Value(accountId),
       memberId = Value(memberId),
       amount = Value(amount),
       contributionDate = Value(contributionDate);
  static Insertable<GoalContributionEntry> custom({
    Expression<String>? id,
    Expression<String>? goalId,
    Expression<String>? accountId,
    Expression<String>? memberId,
    Expression<int>? amount,
    Expression<DateTime>? contributionDate,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (accountId != null) 'account_id': accountId,
      if (memberId != null) 'member_id': memberId,
      if (amount != null) 'amount': amount,
      if (contributionDate != null) 'contribution_date': contributionDate,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalContributionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? goalId,
    Value<String>? accountId,
    Value<String>? memberId,
    Value<Money>? amount,
    Value<DateTime>? contributionDate,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return GoalContributionsTableCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      accountId: accountId ?? this.accountId,
      memberId: memberId ?? this.memberId,
      amount: amount ?? this.amount,
      contributionDate: contributionDate ?? this.contributionDate,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(
        $GoalContributionsTableTable.$converteramount.toSql(amount.value),
      );
    }
    if (contributionDate.present) {
      map['contribution_date'] = Variable<DateTime>(contributionDate.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalContributionsTableCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('accountId: $accountId, ')
          ..write('memberId: $memberId, ')
          ..write('amount: $amount, ')
          ..write('contributionDate: $contributionDate, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringTransactionsTableTable extends RecurringTransactionsTable
    with
        TableInfo<$RecurringTransactionsTableTable, RecurringTransactionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringTransactionsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<Money, int> amount =
      GeneratedColumn<int>(
        'amount',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<Money>($RecurringTransactionsTableTable.$converteramount);
  static const VerificationMeta _transactionTypeMeta = const VerificationMeta(
    'transactionType',
  );
  @override
  late final GeneratedColumn<String> transactionType = GeneratedColumn<String>(
    'transaction_type',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scopeMeta = const VerificationMeta('scope');
  @override
  late final GeneratedColumn<String> scope = GeneratedColumn<String>(
    'scope',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES accounts (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES family_members (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nextRunDateMeta = const VerificationMeta(
    'nextRunDate',
  );
  @override
  late final GeneratedColumn<DateTime> nextRunDate = GeneratedColumn<DateTime>(
    'next_run_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    amount,
    transactionType,
    scope,
    accountId,
    categoryId,
    memberId,
    frequency,
    startDate,
    nextRunDate,
    endDate,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringTransactionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('transaction_type')) {
      context.handle(
        _transactionTypeMeta,
        transactionType.isAcceptableOrUnknown(
          data['transaction_type']!,
          _transactionTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionTypeMeta);
    }
    if (data.containsKey('scope')) {
      context.handle(
        _scopeMeta,
        scope.isAcceptableOrUnknown(data['scope']!, _scopeMeta),
      );
    } else if (isInserting) {
      context.missing(_scopeMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    } else if (isInserting) {
      context.missing(_memberIdMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('next_run_date')) {
      context.handle(
        _nextRunDateMeta,
        nextRunDate.isAcceptableOrUnknown(
          data['next_run_date']!,
          _nextRunDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextRunDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringTransactionEntry map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringTransactionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      amount: $RecurringTransactionsTableTable.$converteramount.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}amount'],
        )!,
      ),
      transactionType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_type'],
      )!,
      scope: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}scope'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      ),
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      nextRunDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_run_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $RecurringTransactionsTableTable createAlias(String alias) {
    return $RecurringTransactionsTableTable(attachedDatabase, alias);
  }

  static TypeConverter<Money, int> $converteramount = const MoneyConverter();
}

class RecurringTransactionEntry extends DataClass
    implements Insertable<RecurringTransactionEntry> {
  final String id;
  final String title;
  final Money amount;
  final String transactionType;
  final String scope;
  final String accountId;
  final String? categoryId;
  final String memberId;
  final String frequency;
  final DateTime startDate;
  final DateTime nextRunDate;
  final DateTime? endDate;
  final bool isActive;
  const RecurringTransactionEntry({
    required this.id,
    required this.title,
    required this.amount,
    required this.transactionType,
    required this.scope,
    required this.accountId,
    this.categoryId,
    required this.memberId,
    required this.frequency,
    required this.startDate,
    required this.nextRunDate,
    this.endDate,
    required this.isActive,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    {
      map['amount'] = Variable<int>(
        $RecurringTransactionsTableTable.$converteramount.toSql(amount),
      );
    }
    map['transaction_type'] = Variable<String>(transactionType);
    map['scope'] = Variable<String>(scope);
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || categoryId != null) {
      map['category_id'] = Variable<String>(categoryId);
    }
    map['member_id'] = Variable<String>(memberId);
    map['frequency'] = Variable<String>(frequency);
    map['start_date'] = Variable<DateTime>(startDate);
    map['next_run_date'] = Variable<DateTime>(nextRunDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  RecurringTransactionsTableCompanion toCompanion(bool nullToAbsent) {
    return RecurringTransactionsTableCompanion(
      id: Value(id),
      title: Value(title),
      amount: Value(amount),
      transactionType: Value(transactionType),
      scope: Value(scope),
      accountId: Value(accountId),
      categoryId: categoryId == null && nullToAbsent
          ? const Value.absent()
          : Value(categoryId),
      memberId: Value(memberId),
      frequency: Value(frequency),
      startDate: Value(startDate),
      nextRunDate: Value(nextRunDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      isActive: Value(isActive),
    );
  }

  factory RecurringTransactionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringTransactionEntry(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      amount: serializer.fromJson<Money>(json['amount']),
      transactionType: serializer.fromJson<String>(json['transactionType']),
      scope: serializer.fromJson<String>(json['scope']),
      accountId: serializer.fromJson<String>(json['accountId']),
      categoryId: serializer.fromJson<String?>(json['categoryId']),
      memberId: serializer.fromJson<String>(json['memberId']),
      frequency: serializer.fromJson<String>(json['frequency']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      nextRunDate: serializer.fromJson<DateTime>(json['nextRunDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      isActive: serializer.fromJson<bool>(json['isActive']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'amount': serializer.toJson<Money>(amount),
      'transactionType': serializer.toJson<String>(transactionType),
      'scope': serializer.toJson<String>(scope),
      'accountId': serializer.toJson<String>(accountId),
      'categoryId': serializer.toJson<String?>(categoryId),
      'memberId': serializer.toJson<String>(memberId),
      'frequency': serializer.toJson<String>(frequency),
      'startDate': serializer.toJson<DateTime>(startDate),
      'nextRunDate': serializer.toJson<DateTime>(nextRunDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  RecurringTransactionEntry copyWith({
    String? id,
    String? title,
    Money? amount,
    String? transactionType,
    String? scope,
    String? accountId,
    Value<String?> categoryId = const Value.absent(),
    String? memberId,
    String? frequency,
    DateTime? startDate,
    DateTime? nextRunDate,
    Value<DateTime?> endDate = const Value.absent(),
    bool? isActive,
  }) => RecurringTransactionEntry(
    id: id ?? this.id,
    title: title ?? this.title,
    amount: amount ?? this.amount,
    transactionType: transactionType ?? this.transactionType,
    scope: scope ?? this.scope,
    accountId: accountId ?? this.accountId,
    categoryId: categoryId.present ? categoryId.value : this.categoryId,
    memberId: memberId ?? this.memberId,
    frequency: frequency ?? this.frequency,
    startDate: startDate ?? this.startDate,
    nextRunDate: nextRunDate ?? this.nextRunDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    isActive: isActive ?? this.isActive,
  );
  RecurringTransactionEntry copyWithCompanion(
    RecurringTransactionsTableCompanion data,
  ) {
    return RecurringTransactionEntry(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      amount: data.amount.present ? data.amount.value : this.amount,
      transactionType: data.transactionType.present
          ? data.transactionType.value
          : this.transactionType,
      scope: data.scope.present ? data.scope.value : this.scope,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      nextRunDate: data.nextRunDate.present
          ? data.nextRunDate.value
          : this.nextRunDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringTransactionEntry(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('transactionType: $transactionType, ')
          ..write('scope: $scope, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('memberId: $memberId, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('nextRunDate: $nextRunDate, ')
          ..write('endDate: $endDate, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    amount,
    transactionType,
    scope,
    accountId,
    categoryId,
    memberId,
    frequency,
    startDate,
    nextRunDate,
    endDate,
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringTransactionEntry &&
          other.id == this.id &&
          other.title == this.title &&
          other.amount == this.amount &&
          other.transactionType == this.transactionType &&
          other.scope == this.scope &&
          other.accountId == this.accountId &&
          other.categoryId == this.categoryId &&
          other.memberId == this.memberId &&
          other.frequency == this.frequency &&
          other.startDate == this.startDate &&
          other.nextRunDate == this.nextRunDate &&
          other.endDate == this.endDate &&
          other.isActive == this.isActive);
}

class RecurringTransactionsTableCompanion
    extends UpdateCompanion<RecurringTransactionEntry> {
  final Value<String> id;
  final Value<String> title;
  final Value<Money> amount;
  final Value<String> transactionType;
  final Value<String> scope;
  final Value<String> accountId;
  final Value<String?> categoryId;
  final Value<String> memberId;
  final Value<String> frequency;
  final Value<DateTime> startDate;
  final Value<DateTime> nextRunDate;
  final Value<DateTime?> endDate;
  final Value<bool> isActive;
  final Value<int> rowid;
  const RecurringTransactionsTableCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.amount = const Value.absent(),
    this.transactionType = const Value.absent(),
    this.scope = const Value.absent(),
    this.accountId = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.frequency = const Value.absent(),
    this.startDate = const Value.absent(),
    this.nextRunDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringTransactionsTableCompanion.insert({
    required String id,
    required String title,
    required Money amount,
    required String transactionType,
    required String scope,
    required String accountId,
    this.categoryId = const Value.absent(),
    required String memberId,
    required String frequency,
    required DateTime startDate,
    required DateTime nextRunDate,
    this.endDate = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       amount = Value(amount),
       transactionType = Value(transactionType),
       scope = Value(scope),
       accountId = Value(accountId),
       memberId = Value(memberId),
       frequency = Value(frequency),
       startDate = Value(startDate),
       nextRunDate = Value(nextRunDate);
  static Insertable<RecurringTransactionEntry> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<int>? amount,
    Expression<String>? transactionType,
    Expression<String>? scope,
    Expression<String>? accountId,
    Expression<String>? categoryId,
    Expression<String>? memberId,
    Expression<String>? frequency,
    Expression<DateTime>? startDate,
    Expression<DateTime>? nextRunDate,
    Expression<DateTime>? endDate,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (amount != null) 'amount': amount,
      if (transactionType != null) 'transaction_type': transactionType,
      if (scope != null) 'scope': scope,
      if (accountId != null) 'account_id': accountId,
      if (categoryId != null) 'category_id': categoryId,
      if (memberId != null) 'member_id': memberId,
      if (frequency != null) 'frequency': frequency,
      if (startDate != null) 'start_date': startDate,
      if (nextRunDate != null) 'next_run_date': nextRunDate,
      if (endDate != null) 'end_date': endDate,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringTransactionsTableCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<Money>? amount,
    Value<String>? transactionType,
    Value<String>? scope,
    Value<String>? accountId,
    Value<String?>? categoryId,
    Value<String>? memberId,
    Value<String>? frequency,
    Value<DateTime>? startDate,
    Value<DateTime>? nextRunDate,
    Value<DateTime?>? endDate,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return RecurringTransactionsTableCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      transactionType: transactionType ?? this.transactionType,
      scope: scope ?? this.scope,
      accountId: accountId ?? this.accountId,
      categoryId: categoryId ?? this.categoryId,
      memberId: memberId ?? this.memberId,
      frequency: frequency ?? this.frequency,
      startDate: startDate ?? this.startDate,
      nextRunDate: nextRunDate ?? this.nextRunDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(
        $RecurringTransactionsTableTable.$converteramount.toSql(amount.value),
      );
    }
    if (transactionType.present) {
      map['transaction_type'] = Variable<String>(transactionType.value);
    }
    if (scope.present) {
      map['scope'] = Variable<String>(scope.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (nextRunDate.present) {
      map['next_run_date'] = Variable<DateTime>(nextRunDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringTransactionsTableCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('amount: $amount, ')
          ..write('transactionType: $transactionType, ')
          ..write('scope: $scope, ')
          ..write('accountId: $accountId, ')
          ..write('categoryId: $categoryId, ')
          ..write('memberId: $memberId, ')
          ..write('frequency: $frequency, ')
          ..write('startDate: $startDate, ')
          ..write('nextRunDate: $nextRunDate, ')
          ..write('endDate: $endDate, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, AppSettingEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<AppSettingEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  AppSettingEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppSettingEntry(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class AppSettingEntry extends DataClass implements Insertable<AppSettingEntry> {
  final String key;
  final String value;
  final DateTime updatedAt;
  const AppSettingEntry({
    required this.key,
    required this.value,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      key: Value(key),
      value: Value(value),
      updatedAt: Value(updatedAt),
    );
  }

  factory AppSettingEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppSettingEntry(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AppSettingEntry copyWith({String? key, String? value, DateTime? updatedAt}) =>
      AppSettingEntry(
        key: key ?? this.key,
        value: value ?? this.value,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  AppSettingEntry copyWithCompanion(AppSettingsTableCompanion data) {
    return AppSettingEntry(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingEntry(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppSettingEntry &&
          other.key == this.key &&
          other.value == this.value &&
          other.updatedAt == this.updatedAt);
}

class AppSettingsTableCompanion extends UpdateCompanion<AppSettingEntry> {
  final Value<String> key;
  final Value<String> value;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AppSettingsTableCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    required String key,
    required String value,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value),
       updatedAt = Value(updatedAt);
  static Insertable<AppSettingEntry> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsTableCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AppSettingsTableCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DeviceInfoTableTable deviceInfoTable = $DeviceInfoTableTable(
    this,
  );
  late final $UserProfileTableTable userProfileTable = $UserProfileTableTable(
    this,
  );
  late final $FamilyMembersTableTable familyMembersTable =
      $FamilyMembersTableTable(this);
  late final $FinancialSpacesTableTable financialSpacesTable =
      $FinancialSpacesTableTable(this);
  late final $AccountsTableTable accountsTable = $AccountsTableTable(this);
  late final $CategoriesTableTable categoriesTable = $CategoriesTableTable(
    this,
  );
  late final $TransfersTableTable transfersTable = $TransfersTableTable(this);
  late final $TransactionsTableTable transactionsTable =
      $TransactionsTableTable(this);
  late final $BudgetsTableTable budgetsTable = $BudgetsTableTable(this);
  late final $BudgetCategoriesTableTable budgetCategoriesTable =
      $BudgetCategoriesTableTable(this);
  late final $SavingsGoalsTableTable savingsGoalsTable =
      $SavingsGoalsTableTable(this);
  late final $GoalContributionsTableTable goalContributionsTable =
      $GoalContributionsTableTable(this);
  late final $RecurringTransactionsTableTable recurringTransactionsTable =
      $RecurringTransactionsTableTable(this);
  late final $AppSettingsTableTable appSettingsTable = $AppSettingsTableTable(
    this,
  );
  late final FamilyMembersDao familyMembersDao = FamilyMembersDao(
    this as AppDatabase,
  );
  late final AccountsDao accountsDao = AccountsDao(this as AppDatabase);
  late final CategoriesDao categoriesDao = CategoriesDao(this as AppDatabase);
  late final TransactionsDao transactionsDao = TransactionsDao(
    this as AppDatabase,
  );
  late final TransfersDao transfersDao = TransfersDao(this as AppDatabase);
  late final BudgetsDao budgetsDao = BudgetsDao(this as AppDatabase);
  late final SavingsGoalsDao savingsGoalsDao = SavingsGoalsDao(
    this as AppDatabase,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    deviceInfoTable,
    userProfileTable,
    familyMembersTable,
    financialSpacesTable,
    accountsTable,
    categoriesTable,
    transfersTable,
    transactionsTable,
    budgetsTable,
    budgetCategoriesTable,
    savingsGoalsTable,
    goalContributionsTable,
    recurringTransactionsTable,
    appSettingsTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'family_members',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('financial_spaces', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'family_members',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('accounts', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('categories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'transfers',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('transactions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'family_members',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budgets', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'budgets',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budget_categories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('budget_categories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'family_members',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('savings_goals', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'savings_goals',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('goal_contributions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recurring_transactions', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$DeviceInfoTableTableCreateCompanionBuilder =
    DeviceInfoTableCompanion Function({
      required String id,
      required String deviceModel,
      required String osVersion,
      required String appVersion,
      required DateTime createdAt,
      required DateTime lastOpenedAt,
      Value<int> rowid,
    });
typedef $$DeviceInfoTableTableUpdateCompanionBuilder =
    DeviceInfoTableCompanion Function({
      Value<String> id,
      Value<String> deviceModel,
      Value<String> osVersion,
      Value<String> appVersion,
      Value<DateTime> createdAt,
      Value<DateTime> lastOpenedAt,
      Value<int> rowid,
    });

class $$DeviceInfoTableTableFilterComposer
    extends Composer<_$AppDatabase, $DeviceInfoTableTable> {
  $$DeviceInfoTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceModel => $composableBuilder(
    column: $table.deviceModel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get osVersion => $composableBuilder(
    column: $table.osVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeviceInfoTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DeviceInfoTableTable> {
  $$DeviceInfoTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceModel => $composableBuilder(
    column: $table.deviceModel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get osVersion => $composableBuilder(
    column: $table.osVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeviceInfoTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeviceInfoTableTable> {
  $$DeviceInfoTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get deviceModel => $composableBuilder(
    column: $table.deviceModel,
    builder: (column) => column,
  );

  GeneratedColumn<String> get osVersion =>
      $composableBuilder(column: $table.osVersion, builder: (column) => column);

  GeneratedColumn<String> get appVersion => $composableBuilder(
    column: $table.appVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastOpenedAt => $composableBuilder(
    column: $table.lastOpenedAt,
    builder: (column) => column,
  );
}

class $$DeviceInfoTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeviceInfoTableTable,
          DeviceInfoEntry,
          $$DeviceInfoTableTableFilterComposer,
          $$DeviceInfoTableTableOrderingComposer,
          $$DeviceInfoTableTableAnnotationComposer,
          $$DeviceInfoTableTableCreateCompanionBuilder,
          $$DeviceInfoTableTableUpdateCompanionBuilder,
          (
            DeviceInfoEntry,
            BaseReferences<
              _$AppDatabase,
              $DeviceInfoTableTable,
              DeviceInfoEntry
            >,
          ),
          DeviceInfoEntry,
          PrefetchHooks Function()
        > {
  $$DeviceInfoTableTableTableManager(
    _$AppDatabase db,
    $DeviceInfoTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeviceInfoTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeviceInfoTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeviceInfoTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> deviceModel = const Value.absent(),
                Value<String> osVersion = const Value.absent(),
                Value<String> appVersion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> lastOpenedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeviceInfoTableCompanion(
                id: id,
                deviceModel: deviceModel,
                osVersion: osVersion,
                appVersion: appVersion,
                createdAt: createdAt,
                lastOpenedAt: lastOpenedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String deviceModel,
                required String osVersion,
                required String appVersion,
                required DateTime createdAt,
                required DateTime lastOpenedAt,
                Value<int> rowid = const Value.absent(),
              }) => DeviceInfoTableCompanion.insert(
                id: id,
                deviceModel: deviceModel,
                osVersion: osVersion,
                appVersion: appVersion,
                createdAt: createdAt,
                lastOpenedAt: lastOpenedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DeviceInfoTableTable, DeviceInfoEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $DeviceInfoTableTable,
                    DeviceInfoEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeviceInfoTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeviceInfoTableTable,
      DeviceInfoEntry,
      $$DeviceInfoTableTableFilterComposer,
      $$DeviceInfoTableTableOrderingComposer,
      $$DeviceInfoTableTableAnnotationComposer,
      $$DeviceInfoTableTableCreateCompanionBuilder,
      $$DeviceInfoTableTableUpdateCompanionBuilder,
      (
        DeviceInfoEntry,
        BaseReferences<_$AppDatabase, $DeviceInfoTableTable, DeviceInfoEntry>,
      ),
      DeviceInfoEntry,
      PrefetchHooks Function()
    >;
typedef $$UserProfileTableTableCreateCompanionBuilder =
    UserProfileTableCompanion Function({
      required String id,
      required String displayName,
      Value<String?> email,
      Value<String> primaryCurrency,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UserProfileTableTableUpdateCompanionBuilder =
    UserProfileTableCompanion Function({
      Value<String> id,
      Value<String> displayName,
      Value<String?> email,
      Value<String> primaryCurrency,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UserProfileTableTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfileTableTable> {
  $$UserProfileTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get primaryCurrency => $composableBuilder(
    column: $table.primaryCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfileTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfileTableTable> {
  $$UserProfileTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get primaryCurrency => $composableBuilder(
    column: $table.primaryCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfileTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfileTableTable> {
  $$UserProfileTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get primaryCurrency => $composableBuilder(
    column: $table.primaryCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UserProfileTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfileTableTable,
          UserProfileEntry,
          $$UserProfileTableTableFilterComposer,
          $$UserProfileTableTableOrderingComposer,
          $$UserProfileTableTableAnnotationComposer,
          $$UserProfileTableTableCreateCompanionBuilder,
          $$UserProfileTableTableUpdateCompanionBuilder,
          (
            UserProfileEntry,
            BaseReferences<
              _$AppDatabase,
              $UserProfileTableTable,
              UserProfileEntry
            >,
          ),
          UserProfileEntry,
          PrefetchHooks Function()
        > {
  $$UserProfileTableTableTableManager(
    _$AppDatabase db,
    $UserProfileTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfileTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfileTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfileTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String?> email = const Value.absent(),
                Value<String> primaryCurrency = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UserProfileTableCompanion(
                id: id,
                displayName: displayName,
                email: email,
                primaryCurrency: primaryCurrency,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String displayName,
                Value<String?> email = const Value.absent(),
                Value<String> primaryCurrency = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UserProfileTableCompanion.insert(
                id: id,
                displayName: displayName,
                email: email,
                primaryCurrency: primaryCurrency,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$UserProfileTableTable, UserProfileEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $UserProfileTableTable,
                    UserProfileEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfileTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfileTableTable,
      UserProfileEntry,
      $$UserProfileTableTableFilterComposer,
      $$UserProfileTableTableOrderingComposer,
      $$UserProfileTableTableAnnotationComposer,
      $$UserProfileTableTableCreateCompanionBuilder,
      $$UserProfileTableTableUpdateCompanionBuilder,
      (
        UserProfileEntry,
        BaseReferences<_$AppDatabase, $UserProfileTableTable, UserProfileEntry>,
      ),
      UserProfileEntry,
      PrefetchHooks Function()
    >;
typedef $$FamilyMembersTableTableCreateCompanionBuilder =
    FamilyMembersTableCompanion Function({
      required String id,
      required String name,
      required String role,
      Value<String?> avatarPath,
      Value<String> colorHex,
      Value<bool> isActive,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$FamilyMembersTableTableUpdateCompanionBuilder =
    FamilyMembersTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> role,
      Value<String?> avatarPath,
      Value<String> colorHex,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$FamilyMembersTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FamilyMembersTableTable,
          FamilyMemberEntry
        > {
  $$FamilyMembersTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $FinancialSpacesTableTable,
    List<FinancialSpaceEntry>
  >
  _financialSpacesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.financialSpacesTable,
        aliasName: 'family_members__id__financial_spaces__member_id',
      );

  $$FinancialSpacesTableTableProcessedTableManager
  get financialSpacesTableRefs {
    final manager = $$FinancialSpacesTableTableTableManager(
      $_db,
      $_db.financialSpacesTable,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _financialSpacesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$AccountsTableTable, List<AccountEntry>>
  _accountsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.accountsTable,
    aliasName: 'family_members__id__accounts__member_id',
  );

  $$AccountsTableTableProcessedTableManager get accountsTableRefs {
    final manager = $$AccountsTableTableTableManager(
      $_db,
      $_db.accountsTable,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_accountsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransfersTableTable, List<TransferEntry>>
  _transfersTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.transfersTable,
    aliasName: 'family_members__id__transfers__member_id',
  );

  $$TransfersTableTableProcessedTableManager get transfersTableRefs {
    final manager = $$TransfersTableTableTableManager(
      $_db,
      $_db.transfersTable,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_transfersTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TransactionsTableTable, List<TransactionEntry>>
  _transactionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionsTable,
        aliasName: 'family_members__id__transactions__member_id',
      );

  $$TransactionsTableTableProcessedTableManager get transactionsTableRefs {
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BudgetsTableTable, List<BudgetEntry>>
  _budgetsTableRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.budgetsTable,
    aliasName: 'family_members__id__budgets__member_id',
  );

  $$BudgetsTableTableProcessedTableManager get budgetsTableRefs {
    final manager = $$BudgetsTableTableTableManager(
      $_db,
      $_db.budgetsTable,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_budgetsTableRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SavingsGoalsTableTable, List<SavingsGoalEntry>>
  _savingsGoalsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.savingsGoalsTable,
        aliasName: 'family_members__id__savings_goals__member_id',
      );

  $$SavingsGoalsTableTableProcessedTableManager get savingsGoalsTableRefs {
    final manager = $$SavingsGoalsTableTableTableManager(
      $_db,
      $_db.savingsGoalsTable,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _savingsGoalsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $GoalContributionsTableTable,
    List<GoalContributionEntry>
  >
  _goalContributionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.goalContributionsTable,
        aliasName: 'family_members__id__goal_contributions__member_id',
      );

  $$GoalContributionsTableTableProcessedTableManager
  get goalContributionsTableRefs {
    final manager = $$GoalContributionsTableTableTableManager(
      $_db,
      $_db.goalContributionsTable,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _goalContributionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RecurringTransactionsTableTable,
    List<RecurringTransactionEntry>
  >
  _recurringTransactionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recurringTransactionsTable,
        aliasName: 'family_members__id__recurring_transactions__member_id',
      );

  $$RecurringTransactionsTableTableProcessedTableManager
  get recurringTransactionsTableRefs {
    final manager = $$RecurringTransactionsTableTableTableManager(
      $_db,
      $_db.recurringTransactionsTable,
    ).filter((f) => f.memberId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recurringTransactionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$FamilyMembersTableTableFilterComposer
    extends Composer<_$AppDatabase, $FamilyMembersTableTable> {
  $$FamilyMembersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> financialSpacesTableRefs(
    Expression<bool> Function($$FinancialSpacesTableTableFilterComposer f) f,
  ) {
    final $$FinancialSpacesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.financialSpacesTable,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FinancialSpacesTableTableFilterComposer(
            $db: $db,
            $table: $db.financialSpacesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> accountsTableRefs(
    Expression<bool> Function($$AccountsTableTableFilterComposer f) f,
  ) {
    final $$AccountsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableFilterComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transfersTableRefs(
    Expression<bool> Function($$TransfersTableTableFilterComposer f) f,
  ) {
    final $$TransfersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transfersTable,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransfersTableTableFilterComposer(
            $db: $db,
            $table: $db.transfersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> transactionsTableRefs(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetsTableRefs(
    Expression<bool> Function($$BudgetsTableTableFilterComposer f) f,
  ) {
    final $$BudgetsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetsTable,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableTableFilterComposer(
            $db: $db,
            $table: $db.budgetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> savingsGoalsTableRefs(
    Expression<bool> Function($$SavingsGoalsTableTableFilterComposer f) f,
  ) {
    final $$SavingsGoalsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.savingsGoalsTable,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingsGoalsTableTableFilterComposer(
            $db: $db,
            $table: $db.savingsGoalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> goalContributionsTableRefs(
    Expression<bool> Function($$GoalContributionsTableTableFilterComposer f) f,
  ) {
    final $$GoalContributionsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.goalContributionsTable,
          getReferencedColumn: (t) => t.memberId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalContributionsTableTableFilterComposer(
                $db: $db,
                $table: $db.goalContributionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> recurringTransactionsTableRefs(
    Expression<bool> Function($$RecurringTransactionsTableTableFilterComposer f)
    f,
  ) {
    final $$RecurringTransactionsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringTransactionsTable,
          getReferencedColumn: (t) => t.memberId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringTransactionsTableTableFilterComposer(
                $db: $db,
                $table: $db.recurringTransactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$FamilyMembersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FamilyMembersTableTable> {
  $$FamilyMembersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FamilyMembersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FamilyMembersTableTable> {
  $$FamilyMembersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get avatarPath => $composableBuilder(
    column: $table.avatarPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> financialSpacesTableRefs<T extends Object>(
    Expression<T> Function($$FinancialSpacesTableTableAnnotationComposer a) f,
  ) {
    final $$FinancialSpacesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.financialSpacesTable,
          getReferencedColumn: (t) => t.memberId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FinancialSpacesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.financialSpacesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> accountsTableRefs<T extends Object>(
    Expression<T> Function($$AccountsTableTableAnnotationComposer a) f,
  ) {
    final $$AccountsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transfersTableRefs<T extends Object>(
    Expression<T> Function($$TransfersTableTableAnnotationComposer a) f,
  ) {
    final $$TransfersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transfersTable,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransfersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.transfersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> transactionsTableRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.memberId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> budgetsTableRefs<T extends Object>(
    Expression<T> Function($$BudgetsTableTableAnnotationComposer a) f,
  ) {
    final $$BudgetsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.budgetsTable,
      getReferencedColumn: (t) => t.memberId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> savingsGoalsTableRefs<T extends Object>(
    Expression<T> Function($$SavingsGoalsTableTableAnnotationComposer a) f,
  ) {
    final $$SavingsGoalsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.savingsGoalsTable,
          getReferencedColumn: (t) => t.memberId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SavingsGoalsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.savingsGoalsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> goalContributionsTableRefs<T extends Object>(
    Expression<T> Function($$GoalContributionsTableTableAnnotationComposer a) f,
  ) {
    final $$GoalContributionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.goalContributionsTable,
          getReferencedColumn: (t) => t.memberId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalContributionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.goalContributionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> recurringTransactionsTableRefs<T extends Object>(
    Expression<T> Function(
      $$RecurringTransactionsTableTableAnnotationComposer a,
    )
    f,
  ) {
    final $$RecurringTransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringTransactionsTable,
          getReferencedColumn: (t) => t.memberId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringTransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.recurringTransactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$FamilyMembersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FamilyMembersTableTable,
          FamilyMemberEntry,
          $$FamilyMembersTableTableFilterComposer,
          $$FamilyMembersTableTableOrderingComposer,
          $$FamilyMembersTableTableAnnotationComposer,
          $$FamilyMembersTableTableCreateCompanionBuilder,
          $$FamilyMembersTableTableUpdateCompanionBuilder,
          (FamilyMemberEntry, $$FamilyMembersTableTableReferences),
          FamilyMemberEntry,
          PrefetchHooks Function({
            bool financialSpacesTableRefs,
            bool accountsTableRefs,
            bool transfersTableRefs,
            bool transactionsTableRefs,
            bool budgetsTableRefs,
            bool savingsGoalsTableRefs,
            bool goalContributionsTableRefs,
            bool recurringTransactionsTableRefs,
          })
        > {
  $$FamilyMembersTableTableTableManager(
    _$AppDatabase db,
    $FamilyMembersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FamilyMembersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FamilyMembersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FamilyMembersTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String?> avatarPath = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FamilyMembersTableCompanion(
                id: id,
                name: name,
                role: role,
                avatarPath: avatarPath,
                colorHex: colorHex,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String role,
                Value<String?> avatarPath = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => FamilyMembersTableCompanion.insert(
                id: id,
                name: name,
                role: role,
                avatarPath: avatarPath,
                colorHex: colorHex,
                isActive: isActive,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FamilyMembersTableTable, FamilyMemberEntry>(
                    table,
                  ),
                  $$FamilyMembersTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                financialSpacesTableRefs = false,
                accountsTableRefs = false,
                transfersTableRefs = false,
                transactionsTableRefs = false,
                budgetsTableRefs = false,
                savingsGoalsTableRefs = false,
                goalContributionsTableRefs = false,
                recurringTransactionsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (financialSpacesTableRefs) db.financialSpacesTable,
                    if (accountsTableRefs) db.accountsTable,
                    if (transfersTableRefs) db.transfersTable,
                    if (transactionsTableRefs) db.transactionsTable,
                    if (budgetsTableRefs) db.budgetsTable,
                    if (savingsGoalsTableRefs) db.savingsGoalsTable,
                    if (goalContributionsTableRefs) db.goalContributionsTable,
                    if (recurringTransactionsTableRefs)
                      db.recurringTransactionsTable,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (financialSpacesTableRefs)
                        await $_getPrefetchedDataByColumns<
                          FamilyMemberEntry,
                          $FamilyMembersTableTable,
                          FinancialSpaceEntry,
                          $FinancialSpacesTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$FamilyMembersTableTableReferences
                              ._financialSpacesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FamilyMembersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).financialSpacesTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'member_id',
                          typedResults: items,
                        ),
                      if (accountsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          FamilyMemberEntry,
                          $FamilyMembersTableTable,
                          AccountEntry,
                          $AccountsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$FamilyMembersTableTableReferences
                              ._accountsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FamilyMembersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).accountsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'member_id',
                          typedResults: items,
                        ),
                      if (transfersTableRefs)
                        await $_getPrefetchedDataByColumns<
                          FamilyMemberEntry,
                          $FamilyMembersTableTable,
                          TransferEntry,
                          $TransfersTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$FamilyMembersTableTableReferences
                              ._transfersTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FamilyMembersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).transfersTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'member_id',
                          typedResults: items,
                        ),
                      if (transactionsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          FamilyMemberEntry,
                          $FamilyMembersTableTable,
                          TransactionEntry,
                          $TransactionsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$FamilyMembersTableTableReferences
                              ._transactionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FamilyMembersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'member_id',
                          typedResults: items,
                        ),
                      if (budgetsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          FamilyMemberEntry,
                          $FamilyMembersTableTable,
                          BudgetEntry,
                          $BudgetsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$FamilyMembersTableTableReferences
                              ._budgetsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FamilyMembersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'member_id',
                          typedResults: items,
                        ),
                      if (savingsGoalsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          FamilyMemberEntry,
                          $FamilyMembersTableTable,
                          SavingsGoalEntry,
                          $SavingsGoalsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$FamilyMembersTableTableReferences
                              ._savingsGoalsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FamilyMembersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).savingsGoalsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'member_id',
                          typedResults: items,
                        ),
                      if (goalContributionsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          FamilyMemberEntry,
                          $FamilyMembersTableTable,
                          GoalContributionEntry,
                          $GoalContributionsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$FamilyMembersTableTableReferences
                              ._goalContributionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FamilyMembersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).goalContributionsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'member_id',
                          typedResults: items,
                        ),
                      if (recurringTransactionsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          FamilyMemberEntry,
                          $FamilyMembersTableTable,
                          RecurringTransactionEntry,
                          $RecurringTransactionsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$FamilyMembersTableTableReferences
                              ._recurringTransactionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$FamilyMembersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringTransactionsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'member_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$FamilyMembersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FamilyMembersTableTable,
      FamilyMemberEntry,
      $$FamilyMembersTableTableFilterComposer,
      $$FamilyMembersTableTableOrderingComposer,
      $$FamilyMembersTableTableAnnotationComposer,
      $$FamilyMembersTableTableCreateCompanionBuilder,
      $$FamilyMembersTableTableUpdateCompanionBuilder,
      (FamilyMemberEntry, $$FamilyMembersTableTableReferences),
      FamilyMemberEntry,
      PrefetchHooks Function({
        bool financialSpacesTableRefs,
        bool accountsTableRefs,
        bool transfersTableRefs,
        bool transactionsTableRefs,
        bool budgetsTableRefs,
        bool savingsGoalsTableRefs,
        bool goalContributionsTableRefs,
        bool recurringTransactionsTableRefs,
      })
    >;
typedef $$FinancialSpacesTableTableCreateCompanionBuilder =
    FinancialSpacesTableCompanion Function({
      required String id,
      required String name,
      required String scope,
      Value<String?> memberId,
      Value<bool> isDefault,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$FinancialSpacesTableTableUpdateCompanionBuilder =
    FinancialSpacesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> scope,
      Value<String?> memberId,
      Value<bool> isDefault,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$FinancialSpacesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $FinancialSpacesTableTable,
          FinancialSpaceEntry
        > {
  $$FinancialSpacesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FamilyMembersTableTable _memberIdTable(_$AppDatabase db) => db
      .familyMembersTable
      .createAlias('financial_spaces__member_id__family_members__id');

  $$FamilyMembersTableTableProcessedTableManager? get memberId {
    final $_column = $_itemColumn<String>('member_id');
    if ($_column == null) return null;
    final manager = $$FamilyMembersTableTableTableManager(
      $_db,
      $_db.familyMembersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$FinancialSpacesTableTableFilterComposer
    extends Composer<_$AppDatabase, $FinancialSpacesTableTable> {
  $$FinancialSpacesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FamilyMembersTableTableFilterComposer get memberId {
    final $$FamilyMembersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableTableFilterComposer(
            $db: $db,
            $table: $db.familyMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FinancialSpacesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $FinancialSpacesTableTable> {
  $$FinancialSpacesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FamilyMembersTableTableOrderingComposer get memberId {
    final $$FamilyMembersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableTableOrderingComposer(
            $db: $db,
            $table: $db.familyMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$FinancialSpacesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $FinancialSpacesTableTable> {
  $$FinancialSpacesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$FamilyMembersTableTableAnnotationComposer get memberId {
    final $$FamilyMembersTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.memberId,
          referencedTable: $db.familyMembersTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FamilyMembersTableTableAnnotationComposer(
                $db: $db,
                $table: $db.familyMembersTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$FinancialSpacesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FinancialSpacesTableTable,
          FinancialSpaceEntry,
          $$FinancialSpacesTableTableFilterComposer,
          $$FinancialSpacesTableTableOrderingComposer,
          $$FinancialSpacesTableTableAnnotationComposer,
          $$FinancialSpacesTableTableCreateCompanionBuilder,
          $$FinancialSpacesTableTableUpdateCompanionBuilder,
          (FinancialSpaceEntry, $$FinancialSpacesTableTableReferences),
          FinancialSpaceEntry,
          PrefetchHooks Function({bool memberId})
        > {
  $$FinancialSpacesTableTableTableManager(
    _$AppDatabase db,
    $FinancialSpacesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FinancialSpacesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FinancialSpacesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FinancialSpacesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> scope = const Value.absent(),
                Value<String?> memberId = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FinancialSpacesTableCompanion(
                id: id,
                name: name,
                scope: scope,
                memberId: memberId,
                isDefault: isDefault,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String scope,
                Value<String?> memberId = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => FinancialSpacesTableCompanion.insert(
                id: id,
                name: name,
                scope: scope,
                memberId: memberId,
                isDefault: isDefault,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$FinancialSpacesTableTable, FinancialSpaceEntry>(
                    table,
                  ),
                  $$FinancialSpacesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({memberId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (memberId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.memberId,
                        referencedTable: $$FinancialSpacesTableTableReferences
                            ._memberIdTable(db),
                        referencedColumn: $$FinancialSpacesTableTableReferences
                            ._memberIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$FinancialSpacesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FinancialSpacesTableTable,
      FinancialSpaceEntry,
      $$FinancialSpacesTableTableFilterComposer,
      $$FinancialSpacesTableTableOrderingComposer,
      $$FinancialSpacesTableTableAnnotationComposer,
      $$FinancialSpacesTableTableCreateCompanionBuilder,
      $$FinancialSpacesTableTableUpdateCompanionBuilder,
      (FinancialSpaceEntry, $$FinancialSpacesTableTableReferences),
      FinancialSpaceEntry,
      PrefetchHooks Function({bool memberId})
    >;
typedef $$AccountsTableTableCreateCompanionBuilder =
    AccountsTableCompanion Function({
      required String id,
      required String name,
      required String accountType,
      required String scope,
      Value<String?> memberId,
      required Money initialBalance,
      required Money currentBalance,
      Value<String> currencyCode,
      Value<String?> institutionName,
      Value<String?> accountNumberLast4,
      Value<bool> isArchived,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AccountsTableTableUpdateCompanionBuilder =
    AccountsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> accountType,
      Value<String> scope,
      Value<String?> memberId,
      Value<Money> initialBalance,
      Value<Money> currentBalance,
      Value<String> currencyCode,
      Value<String?> institutionName,
      Value<String?> accountNumberLast4,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$AccountsTableTableReferences
    extends BaseReferences<_$AppDatabase, $AccountsTableTable, AccountEntry> {
  $$AccountsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FamilyMembersTableTable _memberIdTable(_$AppDatabase db) => db
      .familyMembersTable
      .createAlias('accounts__member_id__family_members__id');

  $$FamilyMembersTableTableProcessedTableManager? get memberId {
    final $_column = $_itemColumn<String>('member_id');
    if ($_column == null) return null;
    final manager = $$FamilyMembersTableTableTableManager(
      $_db,
      $_db.familyMembersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionsTableTable, List<TransactionEntry>>
  _transactionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionsTable,
        aliasName: 'accounts__id__transactions__account_id',
      );

  $$TransactionsTableTableProcessedTableManager get transactionsTableRefs {
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $GoalContributionsTableTable,
    List<GoalContributionEntry>
  >
  _goalContributionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.goalContributionsTable,
        aliasName: 'accounts__id__goal_contributions__account_id',
      );

  $$GoalContributionsTableTableProcessedTableManager
  get goalContributionsTableRefs {
    final manager = $$GoalContributionsTableTableTableManager(
      $_db,
      $_db.goalContributionsTable,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _goalContributionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RecurringTransactionsTableTable,
    List<RecurringTransactionEntry>
  >
  _recurringTransactionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recurringTransactionsTable,
        aliasName: 'accounts__id__recurring_transactions__account_id',
      );

  $$RecurringTransactionsTableTableProcessedTableManager
  get recurringTransactionsTableRefs {
    final manager = $$RecurringTransactionsTableTableTableManager(
      $_db,
      $_db.recurringTransactionsTable,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recurringTransactionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$AccountsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Money, Money, int> get initialBalance =>
      $composableBuilder(
        column: $table.initialBalance,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Money, Money, int> get currentBalance =>
      $composableBuilder(
        column: $table.currentBalance,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountNumberLast4 => $composableBuilder(
    column: $table.accountNumberLast4,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FamilyMembersTableTableFilterComposer get memberId {
    final $$FamilyMembersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableTableFilterComposer(
            $db: $db,
            $table: $db.familyMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionsTableRefs(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> goalContributionsTableRefs(
    Expression<bool> Function($$GoalContributionsTableTableFilterComposer f) f,
  ) {
    final $$GoalContributionsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.goalContributionsTable,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalContributionsTableTableFilterComposer(
                $db: $db,
                $table: $db.goalContributionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> recurringTransactionsTableRefs(
    Expression<bool> Function($$RecurringTransactionsTableTableFilterComposer f)
    f,
  ) {
    final $$RecurringTransactionsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringTransactionsTable,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringTransactionsTableTableFilterComposer(
                $db: $db,
                $table: $db.recurringTransactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AccountsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get initialBalance => $composableBuilder(
    column: $table.initialBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountNumberLast4 => $composableBuilder(
    column: $table.accountNumberLast4,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FamilyMembersTableTableOrderingComposer get memberId {
    final $$FamilyMembersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableTableOrderingComposer(
            $db: $db,
            $table: $db.familyMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AccountsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTableTable> {
  $$AccountsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get accountType => $composableBuilder(
    column: $table.accountType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Money, int> get initialBalance =>
      $composableBuilder(
        column: $table.initialBalance,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Money, int> get currentBalance =>
      $composableBuilder(
        column: $table.currentBalance,
        builder: (column) => column,
      );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get institutionName => $composableBuilder(
    column: $table.institutionName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountNumberLast4 => $composableBuilder(
    column: $table.accountNumberLast4,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$FamilyMembersTableTableAnnotationComposer get memberId {
    final $$FamilyMembersTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.memberId,
          referencedTable: $db.familyMembersTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FamilyMembersTableTableAnnotationComposer(
                $db: $db,
                $table: $db.familyMembersTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> transactionsTableRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> goalContributionsTableRefs<T extends Object>(
    Expression<T> Function($$GoalContributionsTableTableAnnotationComposer a) f,
  ) {
    final $$GoalContributionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.goalContributionsTable,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalContributionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.goalContributionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> recurringTransactionsTableRefs<T extends Object>(
    Expression<T> Function(
      $$RecurringTransactionsTableTableAnnotationComposer a,
    )
    f,
  ) {
    final $$RecurringTransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringTransactionsTable,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringTransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.recurringTransactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$AccountsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTableTable,
          AccountEntry,
          $$AccountsTableTableFilterComposer,
          $$AccountsTableTableOrderingComposer,
          $$AccountsTableTableAnnotationComposer,
          $$AccountsTableTableCreateCompanionBuilder,
          $$AccountsTableTableUpdateCompanionBuilder,
          (AccountEntry, $$AccountsTableTableReferences),
          AccountEntry,
          PrefetchHooks Function({
            bool memberId,
            bool transactionsTableRefs,
            bool goalContributionsTableRefs,
            bool recurringTransactionsTableRefs,
          })
        > {
  $$AccountsTableTableTableManager(_$AppDatabase db, $AccountsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> accountType = const Value.absent(),
                Value<String> scope = const Value.absent(),
                Value<String?> memberId = const Value.absent(),
                Value<Money> initialBalance = const Value.absent(),
                Value<Money> currentBalance = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<String?> institutionName = const Value.absent(),
                Value<String?> accountNumberLast4 = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsTableCompanion(
                id: id,
                name: name,
                accountType: accountType,
                scope: scope,
                memberId: memberId,
                initialBalance: initialBalance,
                currentBalance: currentBalance,
                currencyCode: currencyCode,
                institutionName: institutionName,
                accountNumberLast4: accountNumberLast4,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String accountType,
                required String scope,
                Value<String?> memberId = const Value.absent(),
                required Money initialBalance,
                required Money currentBalance,
                Value<String> currencyCode = const Value.absent(),
                Value<String?> institutionName = const Value.absent(),
                Value<String?> accountNumberLast4 = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AccountsTableCompanion.insert(
                id: id,
                name: name,
                accountType: accountType,
                scope: scope,
                memberId: memberId,
                initialBalance: initialBalance,
                currentBalance: currentBalance,
                currencyCode: currencyCode,
                institutionName: institutionName,
                accountNumberLast4: accountNumberLast4,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AccountsTableTable, AccountEntry>(table),
                  $$AccountsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                memberId = false,
                transactionsTableRefs = false,
                goalContributionsTableRefs = false,
                recurringTransactionsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsTableRefs) db.transactionsTable,
                    if (goalContributionsTableRefs) db.goalContributionsTable,
                    if (recurringTransactionsTableRefs)
                      db.recurringTransactionsTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (memberId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.memberId,
                            referencedTable: $$AccountsTableTableReferences
                                ._memberIdTable(db),
                            referencedColumn: $$AccountsTableTableReferences
                                ._memberIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          AccountEntry,
                          $AccountsTableTable,
                          TransactionEntry,
                          $TransactionsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableTableReferences
                              ._transactionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'account_id',
                          typedResults: items,
                        ),
                      if (goalContributionsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          AccountEntry,
                          $AccountsTableTable,
                          GoalContributionEntry,
                          $GoalContributionsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableTableReferences
                              ._goalContributionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).goalContributionsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'account_id',
                          typedResults: items,
                        ),
                      if (recurringTransactionsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          AccountEntry,
                          $AccountsTableTable,
                          RecurringTransactionEntry,
                          $RecurringTransactionsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$AccountsTableTableReferences
                              ._recurringTransactionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$AccountsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringTransactionsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'account_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$AccountsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTableTable,
      AccountEntry,
      $$AccountsTableTableFilterComposer,
      $$AccountsTableTableOrderingComposer,
      $$AccountsTableTableAnnotationComposer,
      $$AccountsTableTableCreateCompanionBuilder,
      $$AccountsTableTableUpdateCompanionBuilder,
      (AccountEntry, $$AccountsTableTableReferences),
      AccountEntry,
      PrefetchHooks Function({
        bool memberId,
        bool transactionsTableRefs,
        bool goalContributionsTableRefs,
        bool recurringTransactionsTableRefs,
      })
    >;
typedef $$CategoriesTableTableCreateCompanionBuilder =
    CategoriesTableCompanion Function({
      required String id,
      required String name,
      required String iconName,
      required String colorHex,
      required String type,
      required String scope,
      Value<String?> parentId,
      Value<bool> isSystem,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CategoriesTableTableUpdateCompanionBuilder =
    CategoriesTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> iconName,
      Value<String> colorHex,
      Value<String> type,
      Value<String> scope,
      Value<String?> parentId,
      Value<bool> isSystem,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$CategoriesTableTableReferences
    extends
        BaseReferences<_$AppDatabase, $CategoriesTableTable, CategoryEntry> {
  $$CategoriesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTableTable _parentIdTable(_$AppDatabase db) =>
      db.categoriesTable.createAlias('categories__parent_id__categories__id');

  $$CategoriesTableTableProcessedTableManager? get parentId {
    final $_column = $_itemColumn<String>('parent_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableTableManager(
      $_db,
      $_db.categoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_parentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionsTableTable, List<TransactionEntry>>
  _transactionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionsTable,
        aliasName: 'categories__id__transactions__category_id',
      );

  $$TransactionsTableTableProcessedTableManager get transactionsTableRefs {
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $BudgetCategoriesTableTable,
    List<BudgetCategoryEntry>
  >
  _budgetCategoriesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.budgetCategoriesTable,
        aliasName: 'categories__id__budget_categories__category_id',
      );

  $$BudgetCategoriesTableTableProcessedTableManager
  get budgetCategoriesTableRefs {
    final manager = $$BudgetCategoriesTableTableTableManager(
      $_db,
      $_db.budgetCategoriesTable,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _budgetCategoriesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RecurringTransactionsTableTable,
    List<RecurringTransactionEntry>
  >
  _recurringTransactionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.recurringTransactionsTable,
        aliasName: 'categories__id__recurring_transactions__category_id',
      );

  $$RecurringTransactionsTableTableProcessedTableManager
  get recurringTransactionsTableRefs {
    final manager = $$RecurringTransactionsTableTableTableManager(
      $_db,
      $_db.recurringTransactionsTable,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recurringTransactionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableTableFilterComposer get parentId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableFilterComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionsTableRefs(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> budgetCategoriesTableRefs(
    Expression<bool> Function($$BudgetCategoriesTableTableFilterComposer f) f,
  ) {
    final $$BudgetCategoriesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.budgetCategoriesTable,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BudgetCategoriesTableTableFilterComposer(
                $db: $db,
                $table: $db.budgetCategoriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<bool> recurringTransactionsTableRefs(
    Expression<bool> Function($$RecurringTransactionsTableTableFilterComposer f)
    f,
  ) {
    final $$RecurringTransactionsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringTransactionsTable,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringTransactionsTableTableFilterComposer(
                $db: $db,
                $table: $db.recurringTransactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystem => $composableBuilder(
    column: $table.isSystem,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableTableOrderingComposer get parentId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTableTable> {
  $$CategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<bool> get isSystem =>
      $composableBuilder(column: $table.isSystem, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$CategoriesTableTableAnnotationComposer get parentId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.parentId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> transactionsTableRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> budgetCategoriesTableRefs<T extends Object>(
    Expression<T> Function($$BudgetCategoriesTableTableAnnotationComposer a) f,
  ) {
    final $$BudgetCategoriesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.budgetCategoriesTable,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BudgetCategoriesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.budgetCategoriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> recurringTransactionsTableRefs<T extends Object>(
    Expression<T> Function(
      $$RecurringTransactionsTableTableAnnotationComposer a,
    )
    f,
  ) {
    final $$RecurringTransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.recurringTransactionsTable,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$RecurringTransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.recurringTransactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTableTable,
          CategoryEntry,
          $$CategoriesTableTableFilterComposer,
          $$CategoriesTableTableOrderingComposer,
          $$CategoriesTableTableAnnotationComposer,
          $$CategoriesTableTableCreateCompanionBuilder,
          $$CategoriesTableTableUpdateCompanionBuilder,
          (CategoryEntry, $$CategoriesTableTableReferences),
          CategoryEntry,
          PrefetchHooks Function({
            bool parentId,
            bool transactionsTableRefs,
            bool budgetCategoriesTableRefs,
            bool recurringTransactionsTableRefs,
          })
        > {
  $$CategoriesTableTableTableManager(
    _$AppDatabase db,
    $CategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> iconName = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> scope = const Value.absent(),
                Value<String?> parentId = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion(
                id: id,
                name: name,
                iconName: iconName,
                colorHex: colorHex,
                type: type,
                scope: scope,
                parentId: parentId,
                isSystem: isSystem,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String iconName,
                required String colorHex,
                required String type,
                required String scope,
                Value<String?> parentId = const Value.absent(),
                Value<bool> isSystem = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CategoriesTableCompanion.insert(
                id: id,
                name: name,
                iconName: iconName,
                colorHex: colorHex,
                type: type,
                scope: scope,
                parentId: parentId,
                isSystem: isSystem,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CategoriesTableTable, CategoryEntry>(table),
                  $$CategoriesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                parentId = false,
                transactionsTableRefs = false,
                budgetCategoriesTableRefs = false,
                recurringTransactionsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsTableRefs) db.transactionsTable,
                    if (budgetCategoriesTableRefs) db.budgetCategoriesTable,
                    if (recurringTransactionsTableRefs)
                      db.recurringTransactionsTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (parentId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.parentId,
                            referencedTable: $$CategoriesTableTableReferences
                                ._parentIdTable(db),
                            referencedColumn: $$CategoriesTableTableReferences
                                ._parentIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoryEntry,
                          $CategoriesTableTable,
                          TransactionEntry,
                          $TransactionsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableTableReferences
                              ._transactionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                      if (budgetCategoriesTableRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoryEntry,
                          $CategoriesTableTable,
                          BudgetCategoryEntry,
                          $BudgetCategoriesTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableTableReferences
                              ._budgetCategoriesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetCategoriesTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                      if (recurringTransactionsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          CategoryEntry,
                          $CategoriesTableTable,
                          RecurringTransactionEntry,
                          $RecurringTransactionsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableTableReferences
                              ._recurringTransactionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableTableReferences(
                                db,
                                table,
                                p0,
                              ).recurringTransactionsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'category_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTableTable,
      CategoryEntry,
      $$CategoriesTableTableFilterComposer,
      $$CategoriesTableTableOrderingComposer,
      $$CategoriesTableTableAnnotationComposer,
      $$CategoriesTableTableCreateCompanionBuilder,
      $$CategoriesTableTableUpdateCompanionBuilder,
      (CategoryEntry, $$CategoriesTableTableReferences),
      CategoryEntry,
      PrefetchHooks Function({
        bool parentId,
        bool transactionsTableRefs,
        bool budgetCategoriesTableRefs,
        bool recurringTransactionsTableRefs,
      })
    >;
typedef $$TransfersTableTableCreateCompanionBuilder =
    TransfersTableCompanion Function({
      required String id,
      required String sourceAccountId,
      required String destinationAccountId,
      required Money amount,
      required String transferType,
      required String memberId,
      required DateTime transferDate,
      Value<String?> notes,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TransfersTableTableUpdateCompanionBuilder =
    TransfersTableCompanion Function({
      Value<String> id,
      Value<String> sourceAccountId,
      Value<String> destinationAccountId,
      Value<Money> amount,
      Value<String> transferType,
      Value<String> memberId,
      Value<DateTime> transferDate,
      Value<String?> notes,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TransfersTableTableReferences
    extends BaseReferences<_$AppDatabase, $TransfersTableTable, TransferEntry> {
  $$TransfersTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTableTable _sourceAccountIdTable(_$AppDatabase db) => db
      .accountsTable
      .createAlias('transfers__source_account_id__accounts__id');

  $$AccountsTableTableProcessedTableManager get sourceAccountId {
    final $_column = $_itemColumn<String>('source_account_id')!;

    final manager = $$AccountsTableTableTableManager(
      $_db,
      $_db.accountsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_sourceAccountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTableTable _destinationAccountIdTable(_$AppDatabase db) => db
      .accountsTable
      .createAlias('transfers__destination_account_id__accounts__id');

  $$AccountsTableTableProcessedTableManager get destinationAccountId {
    final $_column = $_itemColumn<String>('destination_account_id')!;

    final manager = $$AccountsTableTableTableManager(
      $_db,
      $_db.accountsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(
      _destinationAccountIdTable($_db),
    );
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FamilyMembersTableTable _memberIdTable(_$AppDatabase db) => db
      .familyMembersTable
      .createAlias('transfers__member_id__family_members__id');

  $$FamilyMembersTableTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$FamilyMembersTableTableTableManager(
      $_db,
      $_db.familyMembersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TransactionsTableTable, List<TransactionEntry>>
  _transactionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.transactionsTable,
        aliasName: 'transfers__id__transactions__transfer_id',
      );

  $$TransactionsTableTableProcessedTableManager get transactionsTableRefs {
    final manager = $$TransactionsTableTableTableManager(
      $_db,
      $_db.transactionsTable,
    ).filter((f) => f.transferId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _transactionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TransfersTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransfersTableTable> {
  $$TransfersTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Money, Money, int> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get transferType => $composableBuilder(
    column: $table.transferType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transferDate => $composableBuilder(
    column: $table.transferDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableTableFilterComposer get sourceAccountId {
    final $$AccountsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableFilterComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableFilterComposer get destinationAccountId {
    final $$AccountsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableFilterComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FamilyMembersTableTableFilterComposer get memberId {
    final $$FamilyMembersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableTableFilterComposer(
            $db: $db,
            $table: $db.familyMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> transactionsTableRefs(
    Expression<bool> Function($$TransactionsTableTableFilterComposer f) f,
  ) {
    final $$TransactionsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.transactionsTable,
      getReferencedColumn: (t) => t.transferId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransactionsTableTableFilterComposer(
            $db: $db,
            $table: $db.transactionsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TransfersTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransfersTableTable> {
  $$TransfersTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transferType => $composableBuilder(
    column: $table.transferType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transferDate => $composableBuilder(
    column: $table.transferDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableTableOrderingComposer get sourceAccountId {
    final $$AccountsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableOrderingComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableOrderingComposer get destinationAccountId {
    final $$AccountsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableOrderingComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FamilyMembersTableTableOrderingComposer get memberId {
    final $$FamilyMembersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableTableOrderingComposer(
            $db: $db,
            $table: $db.familyMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransfersTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransfersTableTable> {
  $$TransfersTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Money, int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get transferType => $composableBuilder(
    column: $table.transferType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get transferDate => $composableBuilder(
    column: $table.transferDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$AccountsTableTableAnnotationComposer get sourceAccountId {
    final $$AccountsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.sourceAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableAnnotationComposer get destinationAccountId {
    final $$AccountsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.destinationAccountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FamilyMembersTableTableAnnotationComposer get memberId {
    final $$FamilyMembersTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.memberId,
          referencedTable: $db.familyMembersTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FamilyMembersTableTableAnnotationComposer(
                $db: $db,
                $table: $db.familyMembersTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> transactionsTableRefs<T extends Object>(
    Expression<T> Function($$TransactionsTableTableAnnotationComposer a) f,
  ) {
    final $$TransactionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.transactionsTable,
          getReferencedColumn: (t) => t.transferId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TransactionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.transactionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TransfersTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransfersTableTable,
          TransferEntry,
          $$TransfersTableTableFilterComposer,
          $$TransfersTableTableOrderingComposer,
          $$TransfersTableTableAnnotationComposer,
          $$TransfersTableTableCreateCompanionBuilder,
          $$TransfersTableTableUpdateCompanionBuilder,
          (TransferEntry, $$TransfersTableTableReferences),
          TransferEntry,
          PrefetchHooks Function({
            bool sourceAccountId,
            bool destinationAccountId,
            bool memberId,
            bool transactionsTableRefs,
          })
        > {
  $$TransfersTableTableTableManager(
    _$AppDatabase db,
    $TransfersTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransfersTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransfersTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransfersTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sourceAccountId = const Value.absent(),
                Value<String> destinationAccountId = const Value.absent(),
                Value<Money> amount = const Value.absent(),
                Value<String> transferType = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<DateTime> transferDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransfersTableCompanion(
                id: id,
                sourceAccountId: sourceAccountId,
                destinationAccountId: destinationAccountId,
                amount: amount,
                transferType: transferType,
                memberId: memberId,
                transferDate: transferDate,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sourceAccountId,
                required String destinationAccountId,
                required Money amount,
                required String transferType,
                required String memberId,
                required DateTime transferDate,
                Value<String?> notes = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TransfersTableCompanion.insert(
                id: id,
                sourceAccountId: sourceAccountId,
                destinationAccountId: destinationAccountId,
                amount: amount,
                transferType: transferType,
                memberId: memberId,
                transferDate: transferDate,
                notes: notes,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransfersTableTable, TransferEntry>(table),
                  $$TransfersTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                sourceAccountId = false,
                destinationAccountId = false,
                memberId = false,
                transactionsTableRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (transactionsTableRefs) db.transactionsTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (sourceAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.sourceAccountId,
                            referencedTable: $$TransfersTableTableReferences
                                ._sourceAccountIdTable(db),
                            referencedColumn: $$TransfersTableTableReferences
                                ._sourceAccountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (destinationAccountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.destinationAccountId,
                            referencedTable: $$TransfersTableTableReferences
                                ._destinationAccountIdTable(db),
                            referencedColumn: $$TransfersTableTableReferences
                                ._destinationAccountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (memberId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.memberId,
                            referencedTable: $$TransfersTableTableReferences
                                ._memberIdTable(db),
                            referencedColumn: $$TransfersTableTableReferences
                                ._memberIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (transactionsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          TransferEntry,
                          $TransfersTableTable,
                          TransactionEntry,
                          $TransactionsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$TransfersTableTableReferences
                              ._transactionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TransfersTableTableReferences(
                                db,
                                table,
                                p0,
                              ).transactionsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'transfer_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TransfersTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransfersTableTable,
      TransferEntry,
      $$TransfersTableTableFilterComposer,
      $$TransfersTableTableOrderingComposer,
      $$TransfersTableTableAnnotationComposer,
      $$TransfersTableTableCreateCompanionBuilder,
      $$TransfersTableTableUpdateCompanionBuilder,
      (TransferEntry, $$TransfersTableTableReferences),
      TransferEntry,
      PrefetchHooks Function({
        bool sourceAccountId,
        bool destinationAccountId,
        bool memberId,
        bool transactionsTableRefs,
      })
    >;
typedef $$TransactionsTableTableCreateCompanionBuilder =
    TransactionsTableCompanion Function({
      required String id,
      required Money amount,
      required String transactionType,
      required String scope,
      required String accountId,
      Value<String?> categoryId,
      required String memberId,
      required DateTime transactionDate,
      required String paymentMethod,
      Value<String?> notes,
      Value<bool> hasReceipt,
      Value<String?> receiptPath,
      Value<String?> transferId,
      Value<String?> recurringId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableTableUpdateCompanionBuilder =
    TransactionsTableCompanion Function({
      Value<String> id,
      Value<Money> amount,
      Value<String> transactionType,
      Value<String> scope,
      Value<String> accountId,
      Value<String?> categoryId,
      Value<String> memberId,
      Value<DateTime> transactionDate,
      Value<String> paymentMethod,
      Value<String?> notes,
      Value<bool> hasReceipt,
      Value<String?> receiptPath,
      Value<String?> transferId,
      Value<String?> recurringId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TransactionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TransactionsTableTable,
          TransactionEntry
        > {
  $$TransactionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTableTable _accountIdTable(_$AppDatabase db) =>
      db.accountsTable.createAlias('transactions__account_id__accounts__id');

  $$AccountsTableTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$AccountsTableTableTableManager(
      $_db,
      $_db.accountsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) => db
      .categoriesTable
      .createAlias('transactions__category_id__categories__id');

  $$CategoriesTableTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableTableManager(
      $_db,
      $_db.categoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FamilyMembersTableTable _memberIdTable(_$AppDatabase db) => db
      .familyMembersTable
      .createAlias('transactions__member_id__family_members__id');

  $$FamilyMembersTableTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$FamilyMembersTableTableTableManager(
      $_db,
      $_db.familyMembersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TransfersTableTable _transferIdTable(_$AppDatabase db) =>
      db.transfersTable.createAlias('transactions__transfer_id__transfers__id');

  $$TransfersTableTableProcessedTableManager? get transferId {
    final $_column = $_itemColumn<String>('transfer_id');
    if ($_column == null) return null;
    final manager = $$TransfersTableTableTableManager(
      $_db,
      $_db.transfersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_transferIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TransactionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Money, Money, int> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get hasReceipt => $composableBuilder(
    column: $table.hasReceipt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurringId => $composableBuilder(
    column: $table.recurringId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableTableFilterComposer get accountId {
    final $$AccountsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableFilterComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableFilterComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FamilyMembersTableTableFilterComposer get memberId {
    final $$FamilyMembersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableTableFilterComposer(
            $db: $db,
            $table: $db.familyMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransfersTableTableFilterComposer get transferId {
    final $$TransfersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transferId,
      referencedTable: $db.transfersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransfersTableTableFilterComposer(
            $db: $db,
            $table: $db.transfersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get hasReceipt => $composableBuilder(
    column: $table.hasReceipt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurringId => $composableBuilder(
    column: $table.recurringId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableTableOrderingComposer get accountId {
    final $$AccountsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableOrderingComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FamilyMembersTableTableOrderingComposer get memberId {
    final $$FamilyMembersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableTableOrderingComposer(
            $db: $db,
            $table: $db.familyMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TransfersTableTableOrderingComposer get transferId {
    final $$TransfersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transferId,
      referencedTable: $db.transfersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransfersTableTableOrderingComposer(
            $db: $db,
            $table: $db.transfersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTableTable> {
  $$TransactionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Money, int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<DateTime> get transactionDate => $composableBuilder(
    column: $table.transactionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentMethod => $composableBuilder(
    column: $table.paymentMethod,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<bool> get hasReceipt => $composableBuilder(
    column: $table.hasReceipt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get receiptPath => $composableBuilder(
    column: $table.receiptPath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurringId => $composableBuilder(
    column: $table.recurringId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$AccountsTableTableAnnotationComposer get accountId {
    final $$AccountsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FamilyMembersTableTableAnnotationComposer get memberId {
    final $$FamilyMembersTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.memberId,
          referencedTable: $db.familyMembersTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FamilyMembersTableTableAnnotationComposer(
                $db: $db,
                $table: $db.familyMembersTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$TransfersTableTableAnnotationComposer get transferId {
    final $$TransfersTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.transferId,
      referencedTable: $db.transfersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TransfersTableTableAnnotationComposer(
            $db: $db,
            $table: $db.transfersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TransactionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTableTable,
          TransactionEntry,
          $$TransactionsTableTableFilterComposer,
          $$TransactionsTableTableOrderingComposer,
          $$TransactionsTableTableAnnotationComposer,
          $$TransactionsTableTableCreateCompanionBuilder,
          $$TransactionsTableTableUpdateCompanionBuilder,
          (TransactionEntry, $$TransactionsTableTableReferences),
          TransactionEntry,
          PrefetchHooks Function({
            bool accountId,
            bool categoryId,
            bool memberId,
            bool transferId,
          })
        > {
  $$TransactionsTableTableTableManager(
    _$AppDatabase db,
    $TransactionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<Money> amount = const Value.absent(),
                Value<String> transactionType = const Value.absent(),
                Value<String> scope = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<DateTime> transactionDate = const Value.absent(),
                Value<String> paymentMethod = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<bool> hasReceipt = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
                Value<String?> transferId = const Value.absent(),
                Value<String?> recurringId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsTableCompanion(
                id: id,
                amount: amount,
                transactionType: transactionType,
                scope: scope,
                accountId: accountId,
                categoryId: categoryId,
                memberId: memberId,
                transactionDate: transactionDate,
                paymentMethod: paymentMethod,
                notes: notes,
                hasReceipt: hasReceipt,
                receiptPath: receiptPath,
                transferId: transferId,
                recurringId: recurringId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required Money amount,
                required String transactionType,
                required String scope,
                required String accountId,
                Value<String?> categoryId = const Value.absent(),
                required String memberId,
                required DateTime transactionDate,
                required String paymentMethod,
                Value<String?> notes = const Value.absent(),
                Value<bool> hasReceipt = const Value.absent(),
                Value<String?> receiptPath = const Value.absent(),
                Value<String?> transferId = const Value.absent(),
                Value<String?> recurringId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TransactionsTableCompanion.insert(
                id: id,
                amount: amount,
                transactionType: transactionType,
                scope: scope,
                accountId: accountId,
                categoryId: categoryId,
                memberId: memberId,
                transactionDate: transactionDate,
                paymentMethod: paymentMethod,
                notes: notes,
                hasReceipt: hasReceipt,
                receiptPath: receiptPath,
                transferId: transferId,
                recurringId: recurringId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$TransactionsTableTable, TransactionEntry>(table),
                  $$TransactionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                accountId = false,
                categoryId = false,
                memberId = false,
                transferId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable: $$TransactionsTableTableReferences
                                ._accountIdTable(db),
                            referencedColumn: $$TransactionsTableTableReferences
                                ._accountIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable: $$TransactionsTableTableReferences
                                ._categoryIdTable(db),
                            referencedColumn: $$TransactionsTableTableReferences
                                ._categoryIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (memberId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.memberId,
                            referencedTable: $$TransactionsTableTableReferences
                                ._memberIdTable(db),
                            referencedColumn: $$TransactionsTableTableReferences
                                ._memberIdTable(db)
                                .id,
                          ) as T;
                        }
                        if (transferId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.transferId,
                            referencedTable: $$TransactionsTableTableReferences
                                ._transferIdTable(db),
                            referencedColumn: $$TransactionsTableTableReferences
                                ._transferIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$TransactionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTableTable,
      TransactionEntry,
      $$TransactionsTableTableFilterComposer,
      $$TransactionsTableTableOrderingComposer,
      $$TransactionsTableTableAnnotationComposer,
      $$TransactionsTableTableCreateCompanionBuilder,
      $$TransactionsTableTableUpdateCompanionBuilder,
      (TransactionEntry, $$TransactionsTableTableReferences),
      TransactionEntry,
      PrefetchHooks Function({
        bool accountId,
        bool categoryId,
        bool memberId,
        bool transferId,
      })
    >;
typedef $$BudgetsTableTableCreateCompanionBuilder =
    BudgetsTableCompanion Function({
      required String id,
      required String name,
      required String scope,
      Value<String?> memberId,
      required int month,
      required int year,
      required Money totalLimit,
      Value<bool> isActive,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$BudgetsTableTableUpdateCompanionBuilder =
    BudgetsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> scope,
      Value<String?> memberId,
      Value<int> month,
      Value<int> year,
      Value<Money> totalLimit,
      Value<bool> isActive,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$BudgetsTableTableReferences
    extends BaseReferences<_$AppDatabase, $BudgetsTableTable, BudgetEntry> {
  $$BudgetsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $FamilyMembersTableTable _memberIdTable(_$AppDatabase db) => db
      .familyMembersTable
      .createAlias('budgets__member_id__family_members__id');

  $$FamilyMembersTableTableProcessedTableManager? get memberId {
    final $_column = $_itemColumn<String>('member_id');
    if ($_column == null) return null;
    final manager = $$FamilyMembersTableTableTableManager(
      $_db,
      $_db.familyMembersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $BudgetCategoriesTableTable,
    List<BudgetCategoryEntry>
  >
  _budgetCategoriesTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.budgetCategoriesTable,
        aliasName: 'budgets__id__budget_categories__budget_id',
      );

  $$BudgetCategoriesTableTableProcessedTableManager
  get budgetCategoriesTableRefs {
    final manager = $$BudgetCategoriesTableTableTableManager(
      $_db,
      $_db.budgetCategoriesTable,
    ).filter((f) => f.budgetId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _budgetCategoriesTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BudgetsTableTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Money, Money, int> get totalLimit =>
      $composableBuilder(
        column: $table.totalLimit,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FamilyMembersTableTableFilterComposer get memberId {
    final $$FamilyMembersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableTableFilterComposer(
            $db: $db,
            $table: $db.familyMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> budgetCategoriesTableRefs(
    Expression<bool> Function($$BudgetCategoriesTableTableFilterComposer f) f,
  ) {
    final $$BudgetCategoriesTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.budgetCategoriesTable,
          getReferencedColumn: (t) => t.budgetId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BudgetCategoriesTableTableFilterComposer(
                $db: $db,
                $table: $db.budgetCategoriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BudgetsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get month => $composableBuilder(
    column: $table.month,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get year => $composableBuilder(
    column: $table.year,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalLimit => $composableBuilder(
    column: $table.totalLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FamilyMembersTableTableOrderingComposer get memberId {
    final $$FamilyMembersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableTableOrderingComposer(
            $db: $db,
            $table: $db.familyMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTableTable> {
  $$BudgetsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<int> get month =>
      $composableBuilder(column: $table.month, builder: (column) => column);

  GeneratedColumn<int> get year =>
      $composableBuilder(column: $table.year, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Money, int> get totalLimit =>
      $composableBuilder(
        column: $table.totalLimit,
        builder: (column) => column,
      );

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$FamilyMembersTableTableAnnotationComposer get memberId {
    final $$FamilyMembersTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.memberId,
          referencedTable: $db.familyMembersTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FamilyMembersTableTableAnnotationComposer(
                $db: $db,
                $table: $db.familyMembersTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> budgetCategoriesTableRefs<T extends Object>(
    Expression<T> Function($$BudgetCategoriesTableTableAnnotationComposer a) f,
  ) {
    final $$BudgetCategoriesTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.budgetCategoriesTable,
          getReferencedColumn: (t) => t.budgetId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$BudgetCategoriesTableTableAnnotationComposer(
                $db: $db,
                $table: $db.budgetCategoriesTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$BudgetsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTableTable,
          BudgetEntry,
          $$BudgetsTableTableFilterComposer,
          $$BudgetsTableTableOrderingComposer,
          $$BudgetsTableTableAnnotationComposer,
          $$BudgetsTableTableCreateCompanionBuilder,
          $$BudgetsTableTableUpdateCompanionBuilder,
          (BudgetEntry, $$BudgetsTableTableReferences),
          BudgetEntry,
          PrefetchHooks Function({
            bool memberId,
            bool budgetCategoriesTableRefs,
          })
        > {
  $$BudgetsTableTableTableManager(_$AppDatabase db, $BudgetsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> scope = const Value.absent(),
                Value<String?> memberId = const Value.absent(),
                Value<int> month = const Value.absent(),
                Value<int> year = const Value.absent(),
                Value<Money> totalLimit = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsTableCompanion(
                id: id,
                name: name,
                scope: scope,
                memberId: memberId,
                month: month,
                year: year,
                totalLimit: totalLimit,
                isActive: isActive,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String scope,
                Value<String?> memberId = const Value.absent(),
                required int month,
                required int year,
                required Money totalLimit,
                Value<bool> isActive = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BudgetsTableCompanion.insert(
                id: id,
                name: name,
                scope: scope,
                memberId: memberId,
                month: month,
                year: year,
                totalLimit: totalLimit,
                isActive: isActive,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetsTableTable, BudgetEntry>(table),
                  $$BudgetsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({memberId = false, budgetCategoriesTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (budgetCategoriesTableRefs) db.budgetCategoriesTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (memberId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.memberId,
                            referencedTable: $$BudgetsTableTableReferences
                                ._memberIdTable(db),
                            referencedColumn: $$BudgetsTableTableReferences
                                ._memberIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (budgetCategoriesTableRefs)
                        await $_getPrefetchedDataByColumns<
                          BudgetEntry,
                          $BudgetsTableTable,
                          BudgetCategoryEntry,
                          $BudgetCategoriesTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$BudgetsTableTableReferences
                              ._budgetCategoriesTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$BudgetsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).budgetCategoriesTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'budget_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$BudgetsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTableTable,
      BudgetEntry,
      $$BudgetsTableTableFilterComposer,
      $$BudgetsTableTableOrderingComposer,
      $$BudgetsTableTableAnnotationComposer,
      $$BudgetsTableTableCreateCompanionBuilder,
      $$BudgetsTableTableUpdateCompanionBuilder,
      (BudgetEntry, $$BudgetsTableTableReferences),
      BudgetEntry,
      PrefetchHooks Function({bool memberId, bool budgetCategoriesTableRefs})
    >;
typedef $$BudgetCategoriesTableTableCreateCompanionBuilder =
    BudgetCategoriesTableCompanion Function({
      required String id,
      required String budgetId,
      required String categoryId,
      required Money allocatedLimit,
      Value<int> rowid,
    });
typedef $$BudgetCategoriesTableTableUpdateCompanionBuilder =
    BudgetCategoriesTableCompanion Function({
      Value<String> id,
      Value<String> budgetId,
      Value<String> categoryId,
      Value<Money> allocatedLimit,
      Value<int> rowid,
    });

final class $$BudgetCategoriesTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $BudgetCategoriesTableTable,
          BudgetCategoryEntry
        > {
  $$BudgetCategoriesTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $BudgetsTableTable _budgetIdTable(_$AppDatabase db) =>
      db.budgetsTable.createAlias('budget_categories__budget_id__budgets__id');

  $$BudgetsTableTableProcessedTableManager get budgetId {
    final $_column = $_itemColumn<String>('budget_id')!;

    final manager = $$BudgetsTableTableTableManager(
      $_db,
      $_db.budgetsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_budgetIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) => db
      .categoriesTable
      .createAlias('budget_categories__category_id__categories__id');

  $$CategoriesTableTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableTableManager(
      $_db,
      $_db.categoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BudgetCategoriesTableTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetCategoriesTableTable> {
  $$BudgetCategoriesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Money, Money, int> get allocatedLimit =>
      $composableBuilder(
        column: $table.allocatedLimit,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$BudgetsTableTableFilterComposer get budgetId {
    final $$BudgetsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.budgetId,
      referencedTable: $db.budgetsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableTableFilterComposer(
            $db: $db,
            $table: $db.budgetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableFilterComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetCategoriesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetCategoriesTableTable> {
  $$BudgetCategoriesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allocatedLimit => $composableBuilder(
    column: $table.allocatedLimit,
    builder: (column) => ColumnOrderings(column),
  );

  $$BudgetsTableTableOrderingComposer get budgetId {
    final $$BudgetsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.budgetId,
      referencedTable: $db.budgetsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableTableOrderingComposer(
            $db: $db,
            $table: $db.budgetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetCategoriesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetCategoriesTableTable> {
  $$BudgetCategoriesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Money, int> get allocatedLimit =>
      $composableBuilder(
        column: $table.allocatedLimit,
        builder: (column) => column,
      );

  $$BudgetsTableTableAnnotationComposer get budgetId {
    final $$BudgetsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.budgetId,
      referencedTable: $db.budgetsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BudgetsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.budgetsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BudgetCategoriesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetCategoriesTableTable,
          BudgetCategoryEntry,
          $$BudgetCategoriesTableTableFilterComposer,
          $$BudgetCategoriesTableTableOrderingComposer,
          $$BudgetCategoriesTableTableAnnotationComposer,
          $$BudgetCategoriesTableTableCreateCompanionBuilder,
          $$BudgetCategoriesTableTableUpdateCompanionBuilder,
          (BudgetCategoryEntry, $$BudgetCategoriesTableTableReferences),
          BudgetCategoryEntry,
          PrefetchHooks Function({bool budgetId, bool categoryId})
        > {
  $$BudgetCategoriesTableTableTableManager(
    _$AppDatabase db,
    $BudgetCategoriesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetCategoriesTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$BudgetCategoriesTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$BudgetCategoriesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<Money> allocatedLimit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetCategoriesTableCompanion(
                id: id,
                budgetId: budgetId,
                categoryId: categoryId,
                allocatedLimit: allocatedLimit,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String budgetId,
                required String categoryId,
                required Money allocatedLimit,
                Value<int> rowid = const Value.absent(),
              }) => BudgetCategoriesTableCompanion.insert(
                id: id,
                budgetId: budgetId,
                categoryId: categoryId,
                allocatedLimit: allocatedLimit,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BudgetCategoriesTableTable, BudgetCategoryEntry>(
                    table,
                  ),
                  $$BudgetCategoriesTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({budgetId = false, categoryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (budgetId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.budgetId,
                        referencedTable: $$BudgetCategoriesTableTableReferences
                            ._budgetIdTable(db),
                        referencedColumn: $$BudgetCategoriesTableTableReferences
                            ._budgetIdTable(db)
                            .id,
                      ) as T;
                    }
                    if (categoryId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.categoryId,
                        referencedTable: $$BudgetCategoriesTableTableReferences
                            ._categoryIdTable(db),
                        referencedColumn: $$BudgetCategoriesTableTableReferences
                            ._categoryIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BudgetCategoriesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetCategoriesTableTable,
      BudgetCategoryEntry,
      $$BudgetCategoriesTableTableFilterComposer,
      $$BudgetCategoriesTableTableOrderingComposer,
      $$BudgetCategoriesTableTableAnnotationComposer,
      $$BudgetCategoriesTableTableCreateCompanionBuilder,
      $$BudgetCategoriesTableTableUpdateCompanionBuilder,
      (BudgetCategoryEntry, $$BudgetCategoriesTableTableReferences),
      BudgetCategoryEntry,
      PrefetchHooks Function({bool budgetId, bool categoryId})
    >;
typedef $$SavingsGoalsTableTableCreateCompanionBuilder =
    SavingsGoalsTableCompanion Function({
      required String id,
      required String name,
      required String scope,
      Value<String?> memberId,
      required Money targetAmount,
      required Money currentAmount,
      Value<DateTime?> targetDate,
      Value<String> iconName,
      Value<String> colorHex,
      Value<String> status,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SavingsGoalsTableTableUpdateCompanionBuilder =
    SavingsGoalsTableCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> scope,
      Value<String?> memberId,
      Value<Money> targetAmount,
      Value<Money> currentAmount,
      Value<DateTime?> targetDate,
      Value<String> iconName,
      Value<String> colorHex,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SavingsGoalsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SavingsGoalsTableTable,
          SavingsGoalEntry
        > {
  $$SavingsGoalsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $FamilyMembersTableTable _memberIdTable(_$AppDatabase db) => db
      .familyMembersTable
      .createAlias('savings_goals__member_id__family_members__id');

  $$FamilyMembersTableTableProcessedTableManager? get memberId {
    final $_column = $_itemColumn<String>('member_id');
    if ($_column == null) return null;
    final manager = $$FamilyMembersTableTableTableManager(
      $_db,
      $_db.familyMembersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $GoalContributionsTableTable,
    List<GoalContributionEntry>
  >
  _goalContributionsTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.goalContributionsTable,
        aliasName: 'savings_goals__id__goal_contributions__goal_id',
      );

  $$GoalContributionsTableTableProcessedTableManager
  get goalContributionsTableRefs {
    final manager = $$GoalContributionsTableTableTableManager(
      $_db,
      $_db.goalContributionsTable,
    ).filter((f) => f.goalId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _goalContributionsTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SavingsGoalsTableTableFilterComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTableTable> {
  $$SavingsGoalsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Money, Money, int> get targetAmount =>
      $composableBuilder(
        column: $table.targetAmount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<Money, Money, int> get currentAmount =>
      $composableBuilder(
        column: $table.currentAmount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$FamilyMembersTableTableFilterComposer get memberId {
    final $$FamilyMembersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableTableFilterComposer(
            $db: $db,
            $table: $db.familyMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> goalContributionsTableRefs(
    Expression<bool> Function($$GoalContributionsTableTableFilterComposer f) f,
  ) {
    final $$GoalContributionsTableTableFilterComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.goalContributionsTable,
          getReferencedColumn: (t) => t.goalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalContributionsTableTableFilterComposer(
                $db: $db,
                $table: $db.goalContributionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SavingsGoalsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTableTable> {
  $$SavingsGoalsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get iconName => $composableBuilder(
    column: $table.iconName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get colorHex => $composableBuilder(
    column: $table.colorHex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$FamilyMembersTableTableOrderingComposer get memberId {
    final $$FamilyMembersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableTableOrderingComposer(
            $db: $db,
            $table: $db.familyMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SavingsGoalsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SavingsGoalsTableTable> {
  $$SavingsGoalsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Money, int> get targetAmount =>
      $composableBuilder(
        column: $table.targetAmount,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<Money, int> get currentAmount =>
      $composableBuilder(
        column: $table.currentAmount,
        builder: (column) => column,
      );

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get iconName =>
      $composableBuilder(column: $table.iconName, builder: (column) => column);

  GeneratedColumn<String> get colorHex =>
      $composableBuilder(column: $table.colorHex, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$FamilyMembersTableTableAnnotationComposer get memberId {
    final $$FamilyMembersTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.memberId,
          referencedTable: $db.familyMembersTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FamilyMembersTableTableAnnotationComposer(
                $db: $db,
                $table: $db.familyMembersTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> goalContributionsTableRefs<T extends Object>(
    Expression<T> Function($$GoalContributionsTableTableAnnotationComposer a) f,
  ) {
    final $$GoalContributionsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.goalContributionsTable,
          getReferencedColumn: (t) => t.goalId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$GoalContributionsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.goalContributionsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$SavingsGoalsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SavingsGoalsTableTable,
          SavingsGoalEntry,
          $$SavingsGoalsTableTableFilterComposer,
          $$SavingsGoalsTableTableOrderingComposer,
          $$SavingsGoalsTableTableAnnotationComposer,
          $$SavingsGoalsTableTableCreateCompanionBuilder,
          $$SavingsGoalsTableTableUpdateCompanionBuilder,
          (SavingsGoalEntry, $$SavingsGoalsTableTableReferences),
          SavingsGoalEntry,
          PrefetchHooks Function({
            bool memberId,
            bool goalContributionsTableRefs,
          })
        > {
  $$SavingsGoalsTableTableTableManager(
    _$AppDatabase db,
    $SavingsGoalsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SavingsGoalsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SavingsGoalsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SavingsGoalsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> scope = const Value.absent(),
                Value<String?> memberId = const Value.absent(),
                Value<Money> targetAmount = const Value.absent(),
                Value<Money> currentAmount = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<String> iconName = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SavingsGoalsTableCompanion(
                id: id,
                name: name,
                scope: scope,
                memberId: memberId,
                targetAmount: targetAmount,
                currentAmount: currentAmount,
                targetDate: targetDate,
                iconName: iconName,
                colorHex: colorHex,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required String scope,
                Value<String?> memberId = const Value.absent(),
                required Money targetAmount,
                required Money currentAmount,
                Value<DateTime?> targetDate = const Value.absent(),
                Value<String> iconName = const Value.absent(),
                Value<String> colorHex = const Value.absent(),
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SavingsGoalsTableCompanion.insert(
                id: id,
                name: name,
                scope: scope,
                memberId: memberId,
                targetAmount: targetAmount,
                currentAmount: currentAmount,
                targetDate: targetDate,
                iconName: iconName,
                colorHex: colorHex,
                status: status,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SavingsGoalsTableTable, SavingsGoalEntry>(table),
                  $$SavingsGoalsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({memberId = false, goalContributionsTableRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (goalContributionsTableRefs) db.goalContributionsTable,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (memberId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.memberId,
                            referencedTable: $$SavingsGoalsTableTableReferences
                                ._memberIdTable(db),
                            referencedColumn: $$SavingsGoalsTableTableReferences
                                ._memberIdTable(db)
                                .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (goalContributionsTableRefs)
                        await $_getPrefetchedDataByColumns<
                          SavingsGoalEntry,
                          $SavingsGoalsTableTable,
                          GoalContributionEntry,
                          $GoalContributionsTableTable
                        >(
                          currentTable: table,
                          referencedTable: $$SavingsGoalsTableTableReferences
                              ._goalContributionsTableRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SavingsGoalsTableTableReferences(
                                db,
                                table,
                                p0,
                              ).goalContributionsTableRefs,
                          currentColumn: 'id',
                          referencedColumn: 'goal_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SavingsGoalsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SavingsGoalsTableTable,
      SavingsGoalEntry,
      $$SavingsGoalsTableTableFilterComposer,
      $$SavingsGoalsTableTableOrderingComposer,
      $$SavingsGoalsTableTableAnnotationComposer,
      $$SavingsGoalsTableTableCreateCompanionBuilder,
      $$SavingsGoalsTableTableUpdateCompanionBuilder,
      (SavingsGoalEntry, $$SavingsGoalsTableTableReferences),
      SavingsGoalEntry,
      PrefetchHooks Function({bool memberId, bool goalContributionsTableRefs})
    >;
typedef $$GoalContributionsTableTableCreateCompanionBuilder =
    GoalContributionsTableCompanion Function({
      required String id,
      required String goalId,
      required String accountId,
      required String memberId,
      required Money amount,
      required DateTime contributionDate,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$GoalContributionsTableTableUpdateCompanionBuilder =
    GoalContributionsTableCompanion Function({
      Value<String> id,
      Value<String> goalId,
      Value<String> accountId,
      Value<String> memberId,
      Value<Money> amount,
      Value<DateTime> contributionDate,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$GoalContributionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $GoalContributionsTableTable,
          GoalContributionEntry
        > {
  $$GoalContributionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SavingsGoalsTableTable _goalIdTable(_$AppDatabase db) => db
      .savingsGoalsTable
      .createAlias('goal_contributions__goal_id__savings_goals__id');

  $$SavingsGoalsTableTableProcessedTableManager get goalId {
    final $_column = $_itemColumn<String>('goal_id')!;

    final manager = $$SavingsGoalsTableTableTableManager(
      $_db,
      $_db.savingsGoalsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_goalIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $AccountsTableTable _accountIdTable(_$AppDatabase db) => db
      .accountsTable
      .createAlias('goal_contributions__account_id__accounts__id');

  $$AccountsTableTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$AccountsTableTableTableManager(
      $_db,
      $_db.accountsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FamilyMembersTableTable _memberIdTable(_$AppDatabase db) => db
      .familyMembersTable
      .createAlias('goal_contributions__member_id__family_members__id');

  $$FamilyMembersTableTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$FamilyMembersTableTableTableManager(
      $_db,
      $_db.familyMembersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GoalContributionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GoalContributionsTableTable> {
  $$GoalContributionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Money, Money, int> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get contributionDate => $composableBuilder(
    column: $table.contributionDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$SavingsGoalsTableTableFilterComposer get goalId {
    final $$SavingsGoalsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.savingsGoalsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingsGoalsTableTableFilterComposer(
            $db: $db,
            $table: $db.savingsGoalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableFilterComposer get accountId {
    final $$AccountsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableFilterComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FamilyMembersTableTableFilterComposer get memberId {
    final $$FamilyMembersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableTableFilterComposer(
            $db: $db,
            $table: $db.familyMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalContributionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalContributionsTableTable> {
  $$GoalContributionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get contributionDate => $composableBuilder(
    column: $table.contributionDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$SavingsGoalsTableTableOrderingComposer get goalId {
    final $$SavingsGoalsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.goalId,
      referencedTable: $db.savingsGoalsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SavingsGoalsTableTableOrderingComposer(
            $db: $db,
            $table: $db.savingsGoalsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$AccountsTableTableOrderingComposer get accountId {
    final $$AccountsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableOrderingComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FamilyMembersTableTableOrderingComposer get memberId {
    final $$FamilyMembersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableTableOrderingComposer(
            $db: $db,
            $table: $db.familyMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GoalContributionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalContributionsTableTable> {
  $$GoalContributionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Money, int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<DateTime> get contributionDate => $composableBuilder(
    column: $table.contributionDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$SavingsGoalsTableTableAnnotationComposer get goalId {
    final $$SavingsGoalsTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.goalId,
          referencedTable: $db.savingsGoalsTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SavingsGoalsTableTableAnnotationComposer(
                $db: $db,
                $table: $db.savingsGoalsTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$AccountsTableTableAnnotationComposer get accountId {
    final $$AccountsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FamilyMembersTableTableAnnotationComposer get memberId {
    final $$FamilyMembersTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.memberId,
          referencedTable: $db.familyMembersTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FamilyMembersTableTableAnnotationComposer(
                $db: $db,
                $table: $db.familyMembersTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$GoalContributionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalContributionsTableTable,
          GoalContributionEntry,
          $$GoalContributionsTableTableFilterComposer,
          $$GoalContributionsTableTableOrderingComposer,
          $$GoalContributionsTableTableAnnotationComposer,
          $$GoalContributionsTableTableCreateCompanionBuilder,
          $$GoalContributionsTableTableUpdateCompanionBuilder,
          (GoalContributionEntry, $$GoalContributionsTableTableReferences),
          GoalContributionEntry,
          PrefetchHooks Function({bool goalId, bool accountId, bool memberId})
        > {
  $$GoalContributionsTableTableTableManager(
    _$AppDatabase db,
    $GoalContributionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalContributionsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$GoalContributionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$GoalContributionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> goalId = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<Money> amount = const Value.absent(),
                Value<DateTime> contributionDate = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalContributionsTableCompanion(
                id: id,
                goalId: goalId,
                accountId: accountId,
                memberId: memberId,
                amount: amount,
                contributionDate: contributionDate,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String goalId,
                required String accountId,
                required String memberId,
                required Money amount,
                required DateTime contributionDate,
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalContributionsTableCompanion.insert(
                id: id,
                goalId: goalId,
                accountId: accountId,
                memberId: memberId,
                amount: amount,
                contributionDate: contributionDate,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $GoalContributionsTableTable,
                    GoalContributionEntry
                  >(table),
                  $$GoalContributionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({goalId = false, accountId = false, memberId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (goalId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.goalId,
                            referencedTable:
                                $$GoalContributionsTableTableReferences
                                    ._goalIdTable(db),
                            referencedColumn:
                                $$GoalContributionsTableTableReferences
                                    ._goalIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable:
                                $$GoalContributionsTableTableReferences
                                    ._accountIdTable(db),
                            referencedColumn:
                                $$GoalContributionsTableTableReferences
                                    ._accountIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (memberId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.memberId,
                            referencedTable:
                                $$GoalContributionsTableTableReferences
                                    ._memberIdTable(db),
                            referencedColumn:
                                $$GoalContributionsTableTableReferences
                                    ._memberIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$GoalContributionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalContributionsTableTable,
      GoalContributionEntry,
      $$GoalContributionsTableTableFilterComposer,
      $$GoalContributionsTableTableOrderingComposer,
      $$GoalContributionsTableTableAnnotationComposer,
      $$GoalContributionsTableTableCreateCompanionBuilder,
      $$GoalContributionsTableTableUpdateCompanionBuilder,
      (GoalContributionEntry, $$GoalContributionsTableTableReferences),
      GoalContributionEntry,
      PrefetchHooks Function({bool goalId, bool accountId, bool memberId})
    >;
typedef $$RecurringTransactionsTableTableCreateCompanionBuilder =
    RecurringTransactionsTableCompanion Function({
      required String id,
      required String title,
      required Money amount,
      required String transactionType,
      required String scope,
      required String accountId,
      Value<String?> categoryId,
      required String memberId,
      required String frequency,
      required DateTime startDate,
      required DateTime nextRunDate,
      Value<DateTime?> endDate,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$RecurringTransactionsTableTableUpdateCompanionBuilder =
    RecurringTransactionsTableCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<Money> amount,
      Value<String> transactionType,
      Value<String> scope,
      Value<String> accountId,
      Value<String?> categoryId,
      Value<String> memberId,
      Value<String> frequency,
      Value<DateTime> startDate,
      Value<DateTime> nextRunDate,
      Value<DateTime?> endDate,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$RecurringTransactionsTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecurringTransactionsTableTable,
          RecurringTransactionEntry
        > {
  $$RecurringTransactionsTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $AccountsTableTable _accountIdTable(_$AppDatabase db) => db
      .accountsTable
      .createAlias('recurring_transactions__account_id__accounts__id');

  $$AccountsTableTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$AccountsTableTableTableManager(
      $_db,
      $_db.accountsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $CategoriesTableTable _categoryIdTable(_$AppDatabase db) => db
      .categoriesTable
      .createAlias('recurring_transactions__category_id__categories__id');

  $$CategoriesTableTableProcessedTableManager? get categoryId {
    final $_column = $_itemColumn<String>('category_id');
    if ($_column == null) return null;
    final manager = $$CategoriesTableTableTableManager(
      $_db,
      $_db.categoriesTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $FamilyMembersTableTable _memberIdTable(_$AppDatabase db) => db
      .familyMembersTable
      .createAlias('recurring_transactions__member_id__family_members__id');

  $$FamilyMembersTableTableProcessedTableManager get memberId {
    final $_column = $_itemColumn<String>('member_id')!;

    final manager = $$FamilyMembersTableTableTableManager(
      $_db,
      $_db.familyMembersTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_memberIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecurringTransactionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTableTable> {
  $$RecurringTransactionsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<Money, Money, int> get amount =>
      $composableBuilder(
        column: $table.amount,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextRunDate => $composableBuilder(
    column: $table.nextRunDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$AccountsTableTableFilterComposer get accountId {
    final $$AccountsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableFilterComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableFilterComposer get categoryId {
    final $$CategoriesTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableFilterComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FamilyMembersTableTableFilterComposer get memberId {
    final $$FamilyMembersTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableTableFilterComposer(
            $db: $db,
            $table: $db.familyMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringTransactionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTableTable> {
  $$RecurringTransactionsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get scope => $composableBuilder(
    column: $table.scope,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextRunDate => $composableBuilder(
    column: $table.nextRunDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$AccountsTableTableOrderingComposer get accountId {
    final $$AccountsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableOrderingComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableOrderingComposer get categoryId {
    final $$CategoriesTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableOrderingComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FamilyMembersTableTableOrderingComposer get memberId {
    final $$FamilyMembersTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.memberId,
      referencedTable: $db.familyMembersTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$FamilyMembersTableTableOrderingComposer(
            $db: $db,
            $table: $db.familyMembersTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecurringTransactionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringTransactionsTableTable> {
  $$RecurringTransactionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumnWithTypeConverter<Money, int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get transactionType => $composableBuilder(
    column: $table.transactionType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get scope =>
      $composableBuilder(column: $table.scope, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get nextRunDate => $composableBuilder(
    column: $table.nextRunDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$AccountsTableTableAnnotationComposer get accountId {
    final $$AccountsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.accountsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AccountsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.accountsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$CategoriesTableTableAnnotationComposer get categoryId {
    final $$CategoriesTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categoriesTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableTableAnnotationComposer(
            $db: $db,
            $table: $db.categoriesTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$FamilyMembersTableTableAnnotationComposer get memberId {
    final $$FamilyMembersTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.memberId,
          referencedTable: $db.familyMembersTable,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$FamilyMembersTableTableAnnotationComposer(
                $db: $db,
                $table: $db.familyMembersTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$RecurringTransactionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringTransactionsTableTable,
          RecurringTransactionEntry,
          $$RecurringTransactionsTableTableFilterComposer,
          $$RecurringTransactionsTableTableOrderingComposer,
          $$RecurringTransactionsTableTableAnnotationComposer,
          $$RecurringTransactionsTableTableCreateCompanionBuilder,
          $$RecurringTransactionsTableTableUpdateCompanionBuilder,
          (
            RecurringTransactionEntry,
            $$RecurringTransactionsTableTableReferences,
          ),
          RecurringTransactionEntry,
          PrefetchHooks Function({
            bool accountId,
            bool categoryId,
            bool memberId,
          })
        > {
  $$RecurringTransactionsTableTableTableManager(
    _$AppDatabase db,
    $RecurringTransactionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringTransactionsTableTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$RecurringTransactionsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$RecurringTransactionsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<Money> amount = const Value.absent(),
                Value<String> transactionType = const Value.absent(),
                Value<String> scope = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String?> categoryId = const Value.absent(),
                Value<String> memberId = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> nextRunDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurringTransactionsTableCompanion(
                id: id,
                title: title,
                amount: amount,
                transactionType: transactionType,
                scope: scope,
                accountId: accountId,
                categoryId: categoryId,
                memberId: memberId,
                frequency: frequency,
                startDate: startDate,
                nextRunDate: nextRunDate,
                endDate: endDate,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required Money amount,
                required String transactionType,
                required String scope,
                required String accountId,
                Value<String?> categoryId = const Value.absent(),
                required String memberId,
                required String frequency,
                required DateTime startDate,
                required DateTime nextRunDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurringTransactionsTableCompanion.insert(
                id: id,
                title: title,
                amount: amount,
                transactionType: transactionType,
                scope: scope,
                accountId: accountId,
                categoryId: categoryId,
                memberId: memberId,
                frequency: frequency,
                startDate: startDate,
                nextRunDate: nextRunDate,
                endDate: endDate,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $RecurringTransactionsTableTable,
                    RecurringTransactionEntry
                  >(table),
                  $$RecurringTransactionsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({accountId = false, categoryId = false, memberId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (accountId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.accountId,
                            referencedTable:
                                $$RecurringTransactionsTableTableReferences
                                    ._accountIdTable(db),
                            referencedColumn:
                                $$RecurringTransactionsTableTableReferences
                                    ._accountIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (categoryId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.categoryId,
                            referencedTable:
                                $$RecurringTransactionsTableTableReferences
                                    ._categoryIdTable(db),
                            referencedColumn:
                                $$RecurringTransactionsTableTableReferences
                                    ._categoryIdTable(db)
                                    .id,
                          ) as T;
                        }
                        if (memberId) {
                          state = state.withJoin(
                            currentTable: table,
                            currentColumn: table.memberId,
                            referencedTable:
                                $$RecurringTransactionsTableTableReferences
                                    ._memberIdTable(db),
                            referencedColumn:
                                $$RecurringTransactionsTableTableReferences
                                    ._memberIdTable(db)
                                    .id,
                          ) as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$RecurringTransactionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringTransactionsTableTable,
      RecurringTransactionEntry,
      $$RecurringTransactionsTableTableFilterComposer,
      $$RecurringTransactionsTableTableOrderingComposer,
      $$RecurringTransactionsTableTableAnnotationComposer,
      $$RecurringTransactionsTableTableCreateCompanionBuilder,
      $$RecurringTransactionsTableTableUpdateCompanionBuilder,
      (RecurringTransactionEntry, $$RecurringTransactionsTableTableReferences),
      RecurringTransactionEntry,
      PrefetchHooks Function({bool accountId, bool categoryId, bool memberId})
    >;
typedef $$AppSettingsTableTableCreateCompanionBuilder =
    AppSettingsTableCompanion Function({
      required String key,
      required String value,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AppSettingsTableTableUpdateCompanionBuilder =
    AppSettingsTableCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTableTable,
          AppSettingEntry,
          $$AppSettingsTableTableFilterComposer,
          $$AppSettingsTableTableOrderingComposer,
          $$AppSettingsTableTableAnnotationComposer,
          $$AppSettingsTableTableCreateCompanionBuilder,
          $$AppSettingsTableTableUpdateCompanionBuilder,
          (
            AppSettingEntry,
            BaseReferences<
              _$AppDatabase,
              $AppSettingsTableTable,
              AppSettingEntry
            >,
          ),
          AppSettingEntry,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableTableManager(
    _$AppDatabase db,
    $AppSettingsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsTableCompanion(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsTableCompanion.insert(
                key: key,
                value: value,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppSettingsTableTable, AppSettingEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppSettingsTableTable,
                    AppSettingEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTableTable,
      AppSettingEntry,
      $$AppSettingsTableTableFilterComposer,
      $$AppSettingsTableTableOrderingComposer,
      $$AppSettingsTableTableAnnotationComposer,
      $$AppSettingsTableTableCreateCompanionBuilder,
      $$AppSettingsTableTableUpdateCompanionBuilder,
      (
        AppSettingEntry,
        BaseReferences<_$AppDatabase, $AppSettingsTableTable, AppSettingEntry>,
      ),
      AppSettingEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DeviceInfoTableTableTableManager get deviceInfoTable =>
      $$DeviceInfoTableTableTableManager(_db, _db.deviceInfoTable);
  $$UserProfileTableTableTableManager get userProfileTable =>
      $$UserProfileTableTableTableManager(_db, _db.userProfileTable);
  $$FamilyMembersTableTableTableManager get familyMembersTable =>
      $$FamilyMembersTableTableTableManager(_db, _db.familyMembersTable);
  $$FinancialSpacesTableTableTableManager get financialSpacesTable =>
      $$FinancialSpacesTableTableTableManager(_db, _db.financialSpacesTable);
  $$AccountsTableTableTableManager get accountsTable =>
      $$AccountsTableTableTableManager(_db, _db.accountsTable);
  $$CategoriesTableTableTableManager get categoriesTable =>
      $$CategoriesTableTableTableManager(_db, _db.categoriesTable);
  $$TransfersTableTableTableManager get transfersTable =>
      $$TransfersTableTableTableManager(_db, _db.transfersTable);
  $$TransactionsTableTableTableManager get transactionsTable =>
      $$TransactionsTableTableTableManager(_db, _db.transactionsTable);
  $$BudgetsTableTableTableManager get budgetsTable =>
      $$BudgetsTableTableTableManager(_db, _db.budgetsTable);
  $$BudgetCategoriesTableTableTableManager get budgetCategoriesTable =>
      $$BudgetCategoriesTableTableTableManager(_db, _db.budgetCategoriesTable);
  $$SavingsGoalsTableTableTableManager get savingsGoalsTable =>
      $$SavingsGoalsTableTableTableManager(_db, _db.savingsGoalsTable);
  $$GoalContributionsTableTableTableManager get goalContributionsTable =>
      $$GoalContributionsTableTableTableManager(
        _db,
        _db.goalContributionsTable,
      );
  $$RecurringTransactionsTableTableTableManager
  get recurringTransactionsTable =>
      $$RecurringTransactionsTableTableTableManager(
        _db,
        _db.recurringTransactionsTable,
      );
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
}
