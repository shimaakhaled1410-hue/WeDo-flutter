import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wedo_flutter/data/models/project_model.dart';

abstract class ProjectRemoteDataSource {
  Future<ProjectModel> addProject(ProjectModel project);
  Future<List<ProjectModel>> getProjects(String userId);
  Future<void> deleteProject(String projectId);
  Future<void> updateProject(ProjectModel project);
  Future<void> joinProjectById(String projectId);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  ProjectRemoteDataSourceImpl(this.firestore, this.firebaseAuth);

  @override
  Future<ProjectModel> addProject(ProjectModel project) async {
    final docRef = firestore.collection('projects').doc();
    final currentUser = firebaseAuth.currentUser;
    final userPhoto = currentUser?.photoURL ?? '';
    final userName = currentUser?.displayName ?? 'Owner';
    final projectToSave = ProjectModel(
      id: docRef.id,
      name: project.name,
      iconCodePoint: project.iconCodePoint,
      completedTasks: project.completedTasks,
      totalTasks: project.totalTasks,
      collaboratorsIds: [project.ownerId],
      collaboratorsImages: userPhoto.isNotEmpty ? [userPhoto] : [],
      collaboratorsNames: [userName],
      createdAt: project.createdAt,
      ownerId: project.ownerId,
    );

    await docRef.set(projectToSave.toMap());
    return projectToSave;
  }

  @override
  Future<List<ProjectModel>> getProjects(String userId) async {
    final querySnapshot = await firestore
        .collection('projects')
        .where('collaboratorsIds', arrayContains: userId)
        .get();

    return querySnapshot.docs
        .map((doc) => ProjectModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> joinProjectById(String projectId) async {
    final currentUser = firebaseAuth.currentUser;
    if (currentUser == null) {
      throw Exception('User must be logged in');
    }

    final userId = currentUser.uid;
    final userPhoto = currentUser.photoURL ?? '';
    final userName = currentUser.displayName ?? 'Member';

    await firestore.collection('projects').doc(projectId).update({
      'collaboratorsIds': FieldValue.arrayUnion([userId]),
      'collaboratorsNames': FieldValue.arrayUnion([userName]),
      if (userPhoto.isNotEmpty)
        'collaboratorsImages': FieldValue.arrayUnion([userPhoto]),
    });
  }

  @override
  Future<void> deleteProject(String projectId) async {
    await firestore.collection('projects').doc(projectId).delete();

    final tasksQuery = await firestore
        .collection('tasks')
        .where('projectId', isEqualTo: projectId)
        .get();

    for (var doc in tasksQuery.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Future<void> updateProject(ProjectModel project) async {
    await firestore
        .collection('projects')
        .doc(project.id)
        .update(project.toMap());
  }
}
