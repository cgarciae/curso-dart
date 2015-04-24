library db.service;

import "package:redstone/server.dart" as app;
import 'package:redstone_mapper/plugin.dart';
import 'package:taller/modelos/usuario.dart';
import 'package:redstone_mapper_mongo/manager.dart';
import 'package:redstone_mapper_mongo/service.dart';
import 'package:redstone_mapper_mongo/metadata.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:async';
import 'package:taller/modelos/ref.dart';


class DbService<T extends Ref> extends MongoDbService<T>
{
    DbService (String collectionName, MongoConnection mongoService) : super.fromConnection(mongoService, collectionName);
    
    Future<T> NewGeneric (T obj) async
    {
        await insert (obj);
        
        return obj;
    }
    
    Future<T> GetGeneric (String id, [String errorMsg]) async
    {
        T obj = await findOne
        (
            where.id (StringToId(id))
        );
        
        if (obj == null)
            throw new app.ErrorResponse (400, errorMsg != null ? errorMsg : "$collectionName not found");
        
        return obj;
    }
    
    Future UpdateGeneric (String id, @Decode() T delta) async
    {
        delta.id = null;
        
        try
        {
            await update
            (
                where.id(StringToId(id)),
                delta,
                override: false
            );
        }
        catch (e, s)
        {
            await mongoDb.update
            (
                collectionName,
                where.id(StringToId(id)),
                getModifierBuilder (delta, mongoDb.encode)
            );
        }
    }
    
    Future<Ref> DeleteGeneric (String id) async
    {
        await remove (where.id (StringToId (id)));
        
        return new Ref()
            ..id = id;
    }
}

class MongoConnection implements MongoDb
{
    MongoDb get mongoDb => _mongoDb != null ? _mongoDb : app.request.attributes.dbConn;
    MongoDb _mongoDb;
    
    MongoConnection () {}
    
    MongoConnection.fromMongoDb (this._mongoDb);
    
    @override
    DbCollection collection(String collectionName) => mongoDb.collection(collectionName);
    
    @override
    decode(data, Type type) => mongoDb.decode(data, type);
    
    @override
    encode(data) => mongoDb.encode(data);
    
    @override
    Future<List> find(collection, Type type, [selector]) => mongoDb.find(collection, type, selector);
    
    @override
    Future findOne(collection, Type type, [selector]) => mongoDb.findOne(collection, type, selector);
    
    @override
    Db get innerConn => mongoDb.innerConn;
    
    @override
    Future insert(collection, Object obj) => mongoDb.insert(collection, obj);
    
    @override
    Future insertAll(collection, List objs) => mongoDb.insertAll(collection, objs);
    
    @override
    Future remove(collection, selector) => mongoDb.remove(collection, selector);
    
    @override
    Future save(collection, Object obj) => mongoDb.save(collection, obj);
    
    @override
    Future update(collection, selector, Object obj, {bool override: true, bool upsert: false, bool multiUpdate: false})
        => mongoDb.update(collection, selector, obj, override: override, upsert: upsert, multiUpdate: multiUpdate);
}



ModifierBuilder getModifierBuilder (Object obj, dynamic encoder (dynamic obj))
{
    Map<String, dynamic> map = encoder (obj);
    
    map = cleanMap (map);

    Map mod = {r'$set' : map};

    return new ModifierBuilder()
        ..map = mod;
}

dynamic cleanMap (dynamic json)
{
    if (json is List)
    {
        return json.map (cleanMap).toList();
    }
    else if (json is Map)
    {
        var map = {};
        for (String key in json.keys)
        {
            var value = json[key];
            
            if (value == null)
                continue;
            
            if (value is List || value is Map)
                map[key] = cleanMap (value);
            
            else
                map[key] = value;
        }
        return map;
    }
    else
    {
        return json;
    }
}

String get userId => app.request.headers.authorization;
set userId (String value) => app.request.headers.authorization = value;

ObjectId StringToId (String id) => new ObjectId.fromHexString(id);