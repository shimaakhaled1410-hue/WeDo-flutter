import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wedo_flutter/data/models/project_model.dart';

abstract class ProjectRemoteDataSource {
  Future<ProjectModel> addProject(ProjectModel project);
  Future<List<ProjectModel>> getProjects(String userId);
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
}