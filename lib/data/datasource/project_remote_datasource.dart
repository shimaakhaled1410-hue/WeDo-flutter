import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedo_flutter/data/models/project_model.dart';

abstract class ProjectRemoteDataSource {
  Future<ProjectModel> addProject(ProjectModel project);
  Future<List<ProjectModel>> getProjects(String userId);
  Future<void> deleteProject(String projectId);
  Future<void> updateProject(ProjectModel project);
}

class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final FirebaseFirestore firestore;

  ProjectRemoteDataSourceImpl(this.firestore);

  @override
  Future<ProjectModel> addProject(ProjectModel project) async {
    final docRef = firestore.collection('projects').doc();

    final projectToSave = ProjectModel(
      id: docRef.id,
      name: project.name,
      iconCodePoint: project.iconCodePoint,
      completedTasks: project.completedTasks,
      totalTasks: project.totalTasks,
      collaboratorsImages: project.collaboratorsImages,
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
        .where('ownerId', isEqualTo: userId)
        // .orderBy('createdAt', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => ProjectModel.fromMap(doc.data(), doc.id))
        .toList();
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
