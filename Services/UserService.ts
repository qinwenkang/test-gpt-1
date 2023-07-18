import { Service } from 'typedi'
import { In, InsertResult, Like } from 'typeorm'

import { InjectRepository } from 'typeorm-typedi-extensions'
import UserRepository from 'Domain/Repositories/UserRepository'
import UserRoleRepository from 'Domain/Repositories/UserRoleRepository'
import UserOrgRepository from 'Domain/Repositories/UserOrgRepository'
import UserPurviewRepository from 'Domain/Repositories/UserPurviewRepository'

import { IUserReadService } from '../IServices/IUserReadService'
import { IUserWriteService } from 'Domain/IServices/IUserWriteService'

import { UserUpdate } from 'Domain/Entities/UserEntity'
import { UserAccount } from 'models/UserAccount'
import { UserOrg } from 'models/UserOrg'
import { PagingRequest, PagingResponse } from 'Domain/Entities/PagingEntity'
import logger from 'logger'

@Service()
class UserService implements IUserReadService, IUserWriteService {
  constructor(
    @InjectRepository()
    private userRepository: UserRepository,

    @InjectRepository()
    private userRoleRepository: UserRoleRepository,

    @InjectRepository()
    private userOrgRepository: UserOrgRepository,

    @InjectRepository()
    private userPurviewRepository: UserPurviewRepository
  ) {}

  async getUserByPoliceId(policeId: string) {
    return await this.userRepository.findOne(
      { policeId },
      { relations: ['org', 'role'] }
    )
  }

  async getUserByUserCode(userCode: string) {
    return await this.userRepository.findOne(
      { userCode },
      { relations: ['org', 'role'] }
    )
  }

  async getUserById(userId: number) {
    return await this.userRepository.findOne(
      { id: userId },
      { relations: ['org', 'role'] }
    )
  }

  async getUserByUserName(userName: string) {
    return await this.userRepository.findOne(
      { username: userName },
      { relations: ['org', 'role'] }
    )
  }

  async getUsers() {
    return await this.userRepository.find({
      relations: ['org', 'role'],
    })
  }

  async getUsersByIds(userIds: number[]) {
    return await this.userRepository.find({
      where: { id: In(userIds) },
    })
  }

  async getOrgByIds(orgIds: number[]) {
    return await this.userOrgRepository.find({
      where: { id: In(orgIds) },
    })
  }

  async getOrgByCodes(orgCodes: string[]) {
    return await this.userOrgRepository.find({
      where: { code: In(orgCodes) },
    })
  }

  async getUsersByRole(roleId: number) {
    return await this.userRepository.find({
      where: { roleId },
      relations: ['org', 'role'],
    })
  }

  async getUsersByRoles(roleIds: number[]) {
    return await this.userRepository.find({
      where: { roleId: In(roleIds) },
      relations: ['org', 'role'],
    })
  }

  async getUsersByOrg(orgId: number) {
    return await this.userRepository.find({
      where: { orgId },
      relations: ['org', 'role'],
      order: { name: 'ASC' },
    })
  }

  async getUsersByOrgsRolesAndKeyword(
    orgIds: number[],
    roleIds: number[],
    keyword: string
  ) {
    let whereOptions: any = []

    if (orgIds && orgIds.length > 0) {
      if (keyword && keyword !== '') {
        whereOptions.push({
          name: Like(`%${keyword}%`),
          orgId: In(orgIds),
          roleId: In(roleIds),
        })
        whereOptions.push({
          policeId: Like(`%${keyword}%`),
          orgId: In(orgIds),
          roleId: In(roleIds),
        })
        whereOptions.push({
          orgName: Like(`%${keyword}%`),
          orgId: In(orgIds),
          roleId: In(roleIds),
        })
        whereOptions.push({
          jobDesc: Like(`%${keyword}%`),
          orgId: In(orgIds),
          roleId: In(roleIds),
        })
        whereOptions.push({
          quater: Like(`%${keyword}%`),
          orgId: In(orgIds),
          roleId: In(roleIds),
        })
      } else {
        whereOptions.push({ orgId: In(orgIds), roleId: In(roleIds) })
      }
    } else {
      if (keyword && keyword !== '') {
        whereOptions.push({ name: Like(`%${keyword}%`), roleId: In(roleIds) })
        whereOptions.push({
          policeId: Like(`%${keyword}%`),
          roleId: In(roleIds),
        })
        whereOptions.push({
          orgName: Like(`%${keyword}%`),
          roleId: In(roleIds),
        })
        whereOptions.push({
          jobDesc: Like(`%${keyword}%`),
          roleId: In(roleIds),
        })
        whereOptions.push({ quater: Like(`%${keyword}%`), roleId: In(roleIds) })
      } else {
        whereOptions.push({ roleId: In(roleIds) })
      }
    }

    return await this.userRepository.find({
      where: whereOptions,
      relations: ['org', 'role'],
      order: { name: 'ASC' },
    })
  }

  async getUsersByOrgAndKeyword(orgId: number, keyword: string) {
    let whereOptions: any = []

    if (keyword && keyword !== '') {
      whereOptions.push({ name: Like(`%${keyword}%`), orgId: orgId })
      whereOptions.push({ policeId: Like(`%${keyword}%`), orgId: orgId })
      whereOptions.push({ orgName: Like(`%${keyword}%`), orgId: orgId })
      whereOptions.push({ jobDesc: Like(`%${keyword}%`), orgId: orgId })
      whereOptions.push({ quater: Like(`%${keyword}%`), orgId: orgId })
    } else {
      whereOptions.push({ orgId: orgId })
    }

    return await this.userRepository.find({
      where: whereOptions,
      relations: ['org', 'role'],
      order: { name: 'ASC' },
    })
  }

  async getUsersByOrgs(orgIds: number[]) {
    return await this.userRepository.find({
      where: { orgId: In(orgIds) },
      relations: ['org', 'role'],
    })
  }

  async getUsersByOrgRole(orgId: number, roleId: number) {
    return await this.userRepository.find({
      where: { orgId, roleId: roleId },
      relations: ['org', 'role'],
    })
  }

  async getUsersByOrgsRoles(orgIds: number[], roleIds: number[]) {
    return await this.userRepository.find({
      where: { orgId: In(orgIds), roleId: In(roleIds) },
      relations: ['org', 'role'],
    })
  }

  async searchUsers(
    orgIds: number[],
    roleIds: number[],
    keyword: string,
    syncOrder: number,
    paging: PagingRequest
  ): Promise<PagingResponse<UserAccount>> {
    let whereOptions: any = []

    if (keyword && keyword !== '') {
      whereOptions.push({ name: Like(`%${keyword}%`), orgId: In(orgIds) })
      whereOptions.push({ policeId: Like(`%${keyword}%`), orgId: In(orgIds) })
      whereOptions.push({ orgName: Like(`%${keyword}%`), orgId: In(orgIds) })
      whereOptions.push({ jobDesc: Like(`%${keyword}%`), orgId: In(orgIds) })
      whereOptions.push({ quater: Like(`%${keyword}%`), orgId: In(orgIds) })
    } else {
      if (orgIds && orgIds.length > 0) {
        whereOptions.push({ orgId: In(orgIds) })
      }
    }

    let orderOption: any = {}
    if (syncOrder === 1) {
      orderOption = { is4ANew: 'DESC' }
    } else {
      orderOption = { id: 'DESC' }
    }

    let result = await this.userRepository.findAndCount({
      where: whereOptions,
      relations: ['org', 'role'],
      order: orderOption,
      skip: paging.getSkip(),
      take: paging.getTake(),
    })

    let response: PagingResponse<UserAccount> = {
      data: result[0],
      total: result[1],
    }

    return response
  }

  async getUserCount() {
    return await this.userRepository.count()
  }

  async getOrgCount() {
    return await this.userOrgRepository.count()
  }

  async getOrgById(orgId: number) {
    return await this.userOrgRepository.findOne({ id: orgId })
  }

  async getOrgs() {
    return await this.userOrgRepository.find()
  }

  async getRoleById(roleId: number) {
    return await this.userRoleRepository.findOne({ id: roleId })
  }

  async getRoles() {
    return await this.userRoleRepository.find()
  }

  async getRolesByIds(roleIds: number[]) {
    return await this.userRoleRepository.find({
      where: { roleId: In(roleIds) },
    })
  }

  async getPurviews() {
    return await this.userPurviewRepository.find()
  }

  async getPurviewsByModule(module: string) {
    return await this.userPurviewRepository.find({
      where: { moduleAlias: module },
    })
  }

  async updateUser(userId: number, data: UserUpdate) {
    if (data?.orgId != 0) {
      let org = await this.getOrgById(data.orgId!)
      data.orgName = org?.name
    }

    const updateResult = await this.userRepository.update({ id: userId }, data)
    return updateResult.affected !== undefined && updateResult.affected > 0
  }

  async updateUserFull(userId: number, data: UserAccount) {
    const updateResult = await this.userRepository.update({ id: userId }, data)
    return updateResult.affected !== undefined && updateResult.affected > 0
  }

  async updateUserAuthStatus(userId: number, authStatus: number) {
    await this.userRepository.update({ id: userId }, { authStatus })
  }

  async updateOrgFull(orgId: number, data: UserOrg) {
    const updateResult = await this.userOrgRepository.update(
      { id: orgId },
      data
    )
    return updateResult.affected !== undefined && updateResult.affected > 0
  }

  async deleteUserByIds(userIds: number[]) {
    try {
      this.userRepository.softDelete({
        id: In(userIds),
      })
    } catch (err) {
      logger.error('deleteUserByIds', userIds)
    }
  }

  async createUserBatch(users: UserAccount[]): Promise<InsertResult> {
    try {
      return await this.userRepository.insert(users)
    } catch (err) {
      throw err
    }
  }

  async deleteOrgByIds(orgIds: number[]) {
    try {
      this.userOrgRepository.softDelete({
        id: In(orgIds),
      })
    } catch (err) {
      logger.error('deleteOrgByIds', orgIds)
    }
  }

  async createOrgBatch(orgs: UserOrg[]): Promise<InsertResult> {
    try {
      return await this.userOrgRepository.insert(orgs)
    } catch (err) {
      throw err
    }
  }
}

export default UserService
