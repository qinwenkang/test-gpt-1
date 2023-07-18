import { Service } from 'typedi'
import { Between, getConnection, In, Like, UpdateResult, MoreThan, getManager  } from 'typeorm'

import { InjectRepository } from 'typeorm-typedi-extensions'
import TemplateRpository from 'Domain/Repositories/TemplateRpository'
import EntityRepository from 'Domain/Repositories/EntityRepository'
import MissionRecordRepository from 'Domain/Repositories/MissionRecordRepository'

import { IFormReadService } from '../IServices/IFormReadService'
import { IFormWriteService } from 'Domain/IServices/IFormWriteService'

import DateRangeTypeEnum from 'Enums/DateRangeTypeEnum'
import { RoleEnum } from 'Enums/RoleEnum'
import { Entity } from 'models/Entity'
import { MissionRecord } from 'models/MissionRecord'
import { AssessmentItem } from 'models/AssessmentItem'
import { Template } from 'models/Template'
import {
  EntityUpdate,
  CreateMissionRecord,
  EntityWithUser,
  CreateAssessmentItem,
} from 'Domain/Entities/Entity'
import logger from 'logger'
import EntityStatusEnum from 'Enums/EntityStatusEnum'
import { PagingRequest, PagingResponse } from 'Domain/Entities/PagingEntity'
import AssessmentItemRepository from 'Domain/Repositories/AssessmentItemRepository'
import AssessmentTypeEnum from 'Enums/AssessmentTypeEnum'

import { cipher, decipher } from 'Infrastructure'
import { SuperviseRecord } from 'models/SuperviseRecord'
import SuperviseRecordRepository from 'Domain/Repositories/SuperviseRecordRepository'
import moment = require('moment')

@Service()
class FormService implements IFormReadService, IFormWriteService {
  constructor(
    @InjectRepository()
    private templateRepository: TemplateRpository,

    @InjectRepository()
    private entityRepository: EntityRepository,

    @InjectRepository()
    private missionRecordRepository: MissionRecordRepository,

    @InjectRepository()
    private assessmentItemRepository: AssessmentItemRepository,

    @InjectRepository()
    private superviseRecordRepository: SuperviseRecordRepository,
  ) { }

  async getTemplateById(id: number): Promise<Template | undefined> {
    return await this.templateRepository.findOne(id)
  }

  async getTemplateByKey(key: string): Promise<Template | undefined> {
    return await this.templateRepository.findOne({ key: key })
  }

  async getTemplatesByRoleId(
    roleId: number,
    majorMenu?: string,
    repeatable?: boolean
  ): Promise<Template[] | undefined> {
    let whereOptions: any = {
      roleIds: Like(`%${roleId}%`),
      repeatable: repeatable,
    }

    if (majorMenu && majorMenu !== '') {
      whereOptions.majorMenu = majorMenu
    }

    return await this.templateRepository.find({
      where: whereOptions,
    })
  }

  async getTemplatesByRole(
    minorMenu: string,
    roleId: number
  ): Promise<Template[] | undefined> {
    return await this.templateRepository.find({
      where: {
        minorMenu,
        roleIds: Like(`%${roleId}%`),
      },
    })
  }
  async getTemplatesByRoles(
    minorMenu: string,
    roleIds: RoleEnum[]
  ): Promise<Template[] | undefined> {
    let roleLikeSql: string[] = []

    roleIds.forEach((roleId) => {
      roleLikeSql.push(` roleIds like '%${roleId}%' `)
    })

    return await this.templateRepository
      .createQueryBuilder()
      .where(`minorMenu=:minorMenu and (${roleLikeSql.join('OR')})`, {
        minorMenu,
      })
      .getMany()
  }

  async getTemplateByIds(ids: number[]): Promise<Template[] | undefined> {
    return await this.templateRepository.find({
      where: { id: In(ids) }
    })
  }

  async getTemplatesByMajor(majorMenu?: string): Promise<Template[] | undefined> {
    return await this.templateRepository.find({
      where: {
        majorMenu: majorMenu
      },
      order: { key: 'ASC' },
    })
  }

  async getEntityById(id: number): Promise<Entity | undefined> {
    let entity = await this.entityRepository.findOne(id, {
      relations: ['template', 'createdBy', 'handler'],
    })

    // 解密 data
    if (entity && entity.dataStr && entity.dataStr !== '') {
      const decipherData = decipher(entity.dataStr)
      if (decipherData) {
        try {
          entity.data = JSON.parse(decipherData)
        } catch (ex) {
          logger.error('解密脱敏数据异常：', ex)
        }
      }
    }

    return entity
  }

  async getEntitiesByUser(
    userId: number,
    orgId: number,
    minorMenu: string,
    templateId: number,
    keyword: string,
    paging: PagingRequest
  ): Promise<PagingResponse<EntityWithUser>> {
    let sqlCount = `
      select count(1) as total
      from entity as E
        left join user_account U
        on U.id = E.createdById
        where E.minorMenu = ?
        and E.deletedAt is null
        and E.createdById = ${userId}
        and E.orgId = ${orgId}
        and E.status in ('${EntityStatusEnum.草稿}','${EntityStatusEnum.已提交}','${EntityStatusEnum.已完成}')
    `
    let sql = `
      select E.*,
      U.id as U_id,
      U.name as U_name,
      U.policeId as U_policeId,
      U.orgId as U_orgId,
      U.jobDesc as U_jobDesc,
      U.quater as U_quater,
      UO.name as U_orgName
      from entity as E
        left join user_account U
        on U.id = E.createdById
        left join user_org UO
        on UO.id = U.orgId
        where E.minorMenu = ?
        and E.deletedAt is null
        and E.createdById = ${userId}
        and E.orgId = ${orgId}
        and E.status in ('${EntityStatusEnum.草稿}','${EntityStatusEnum.已提交}','${EntityStatusEnum.已完成}')
    `

    if (templateId > 0) {
      sql += ` and E.templateId = ${templateId} `
      sqlCount += ` and E.templateId = ${templateId} `
    }

    if (keyword != '') {
      sql += ` and E.keywords like ?`
      sqlCount += ` and E.keywords like ?`
    }

    sql += ` order by E.updatedAt desc`
    sql += ` limit ${paging.getTake()} offset ${paging.getSkip()} `

    sqlCount += ` order by E.updatedAt desc`

    let dataResult = await getConnection().query(sql, [
      minorMenu,
      `%${keyword}%`,
    ])
    let countResult = await getConnection().query(sqlCount, [
      minorMenu,
      `%${keyword}%`,
    ])

    let response = new PagingResponse<EntityWithUser>()
    response.total = countResult[0]?.total
    response.data = dataResult
    // 解密 data
    if (response.data && response.data.length > 0) {
      response.data.forEach(it => {
        if (it.dataStr) {
          try {
            it.data = decipher(it.dataStr)
          } catch (ex) {
            logger.error('解密脱敏数据异常：', ex)
          }
        }
      })
    }
    return response
  }

  async getEntitiesByHandler(
    handlerId: number,
    minorMenu: string,
    templateId: number,
    keyword: string,
    paging: PagingRequest
  ): Promise<PagingResponse<EntityWithUser>> {
    let sqlCount = `
      select count(1) as total
      from entity as E
        left join user_account U
        on U.id = E.handlerId
        where E.minorMenu = ?
        and E.deletedAt is null
        and E.handlerId = ${handlerId}
        and E.status in ('${EntityStatusEnum.已提交}','${EntityStatusEnum.已完成}')
    `
    let sql = `
      select E.*,
      U.id as U_id,
      U.name as U_name,
      U.policeId as U_policeId,
      U.orgId as U_orgId,
      U.jobDesc as U_jobDesc,
      U.quater as U_quater,
      UO.name as U_orgName
      from entity as E
        left join user_account U
        on U.id = E.handlerId
        left join user_org UO
        on UO.id = U.orgId
        where E.minorMenu = ?
        and E.deletedAt is null
        and E.handlerId = ${handlerId}
        and E.status in ('${EntityStatusEnum.已提交}','${EntityStatusEnum.已完成}')
    `

    if (templateId > 0) {
      sql += ` and E.templateId = ${templateId} `
      sqlCount += ` and E.templateId = ${templateId} `
    }

    if (keyword != '') {
      sql += ` and E.keywords like ?`
      sqlCount += ` and E.keywords like ?`
    }

    sql += ` order by E.updatedAt desc`
    sql += ` limit ${paging.getTake()} offset ${paging.getSkip()} `

    sqlCount += ` order by E.updatedAt desc`

    let dataResult = await getConnection().query(sql, [
      minorMenu,
      `%${keyword}%`,
    ])
    let countResult = await getConnection().query(sqlCount, [
      minorMenu,
      `%${keyword}%`,
    ])

    let response = new PagingResponse<EntityWithUser>()
    response.total = countResult[0]?.total
    response.data = dataResult
    // 解密 data
    if (response.data && response.data.length > 0) {
      response.data.forEach(it => {
        if (it.dataStr) {
          try {
            it.data = decipher(it.dataStr)
          } catch (ex) {
            logger.error('解密脱敏数据异常：', ex)
          }
        }
      })
    }
    return response
  }

  async getEntitiesByOwner(
    ownerId: number,
    minorMenu: string,
    keyword: string,
    paging: PagingRequest
  ): Promise<PagingResponse<EntityWithUser>> {
    let sqlCount = `
    SELECT count(1) as total
      FROM reminder as R
      join entity as E
      on E.id = R.entityId
      left join user_account as U
      on U.id = R.ownerId
      where R.ownerId = ${ownerId}
      and E.deletedAt is null
      and R.minorMenu = ?
      and E.status in ('${EntityStatusEnum.已提交}','${EntityStatusEnum.已完成}')
      and R.status in ('${EntityStatusEnum.已提交}','${EntityStatusEnum.已完成}')
      `
    let sql = `
      SELECT E.*, R.isRead,
      U.id as U_id,
      U.name as U_name,
      U.policeId as U_policeId,
      U.orgId as U_orgId,
      U.jobDesc as U_jobDesc,
      U.quater as U_quater,
      UO.name as U_orgName
      FROM reminder as R
      join entity as E
      on E.id = R.entityId
      left join user_account as U
      on U.id = R.ownerId
      left join user_org UO
      on UO.id = U.orgId
      where R.ownerId = ${ownerId}
      and E.deletedAt is null
      and R.minorMenu = ?
      and E.status in ('${EntityStatusEnum.已提交}','${EntityStatusEnum.已完成}')
      and R.status in ('${EntityStatusEnum.已提交}','${EntityStatusEnum.已完成}')
    `

    if (keyword != '') {
      sql += ` and E.keywords like ?`
      sqlCount += ` and E.keywords like ?`
    }

    sql += ` order by E.updatedAt desc`
    sql += ` limit ${paging.getTake()} offset ${paging.getSkip()} `

    sqlCount += ` order by E.updatedAt desc`

    let dataResult = await getConnection().query(sql, [
      minorMenu,
      `%${keyword}%`,
    ])
    let countResult = await getConnection().query(sqlCount, [
      minorMenu,
      `%${keyword}%`,
    ])

    let response = new PagingResponse<EntityWithUser>()
    response.total = countResult[0]?.total
    response.data = dataResult

    // 解密 data
    if (response.data && response.data.length > 0) {
      response.data.forEach(it => {
        if (it.dataStr) {
          try {
            it.data = decipher(it.dataStr)
          } catch (ex) {
            logger.error('解密脱敏数据异常：', ex)
          }
        }
      })
    }
    return response
  }

  // 也许只有四则协同可以用这个service
  async getEntities(
    minorMenu: string,
    templateId: number,
    orgIds: number[],
    roleIds: number[],
    keyword: string,
    paging: PagingRequest,
    status: EntityStatusEnum[] = [EntityStatusEnum.已提交, EntityStatusEnum.已完成]
  ): Promise<PagingResponse<EntityWithUser>> {

    let statusStr = status.join("','")
    let sqlCount = `
      select count(1) as total
      from entity as E
        left join user_account U
        on U.id = E.createdById
        where E.minorMenu = ?
        and E.deletedAt is null
        and E.status in ('${statusStr}')
    `
    let sql = `
      select E.*,
      U.id as U_id,
      U.name as U_name,
      U.policeId as U_policeId,
      U.orgId as U_orgId,
      U.jobDesc as U_jobDesc,
      U.quater as U_quater,
      UO.name as U_orgName
      from entity as E
        left join user_account U
        on U.id = E.createdById
        left join user_org UO
        on UO.id = U.orgId
        where E.minorMenu = ?
        and E.deletedAt is null
        and E.status in ('${statusStr}')
    `

    if (templateId > 0) {
      sql += ` and E.templateId = ${templateId} `
      sqlCount += ` and E.templateId = ${templateId} `
    }

    if (orgIds.length > 0) {
      sql += ` and E.orgId in (${orgIds.join(',')}) `
      sqlCount += ` and E.orgId in (${orgIds.join(',')}) `
    }

    if (roleIds.length > 0) {
      sql += ` and E.roleId in (${roleIds.join(',')}) `
      sqlCount += ` and E.roleId in (${roleIds.join(',')}) `
    }

    if (keyword != '') {
      sql += ` and E.keywords like ?`
      sqlCount += ` and E.keywords like ?`
    }

    sql += ` order by E.updatedAt desc`
    sql += ` limit ${paging.getTake()} offset ${paging.getSkip()} `

    sqlCount += ` order by E.updatedAt desc`

    let dataResult = await getConnection().query(sql, [
      minorMenu,
      `%${keyword}%`,
    ])
    let countResult = await getConnection().query(sqlCount, [
      minorMenu,
      `%${keyword}%`,
    ])

    let response = new PagingResponse<EntityWithUser>()
    response.total = countResult[0]?.total
    response.data = dataResult

    // 解密 data
    if (response.data && response.data.length > 0) {
      response.data.forEach(it => {
        if (it.dataStr) {
          try {
            it.data = decipher(it.dataStr)
          } catch (ex) {
            logger.error('解密脱敏数据异常：', ex)
          }
        }
      })
    }

    return response
  }

  async getPlanedEntities(
    handlerId: number,
    status: EntityStatusEnum
  ): Promise<Entity[]> {
    return await this.entityRepository.find({
      where: {
        handlerId: handlerId,
        status: status,
      },
      relations: ['handler'],
      order: { id: 'DESC' },
    })
  }

  async getEntiiesByStatus(
    minorMenu: string,
    status: EntityStatusEnum,
    keyword: string,
    paging: PagingRequest
  ): Promise<PagingResponse<EntityWithUser>> {
    let sqlCount = `
      select count(1) as total
      from entity as E
        left join user_account U
        on U.id = E.createdById
        where E.minorMenu = ?
        and E.deletedAt is null
        and E.status = '${status}'
    `
    let sql = `
      select E.*,
      U.id as U_id,
      U.name as U_name,
      U.policeId as U_policeId,
      U.orgId as U_orgId,
      U.jobDesc as U_jobDesc,
      U.quater as U_quater,
      UO.name as U_orgName
      from entity as E
        left join user_account U
        on U.id = E.createdById
        left join user_org UO
        on UO.id = U.orgId
        where E.minorMenu = ?
        and E.deletedAt is null
        and E.status = '${status}'
    `

    if (keyword != '') {
      sql += ` and E.keywords like ?`
      sqlCount += ` and E.keywords like ?`
    }

    sql += ` order by E.updatedAt desc`
    sql += ` limit ${paging.getTake()} offset ${paging.getSkip()} `

    sqlCount += ` order by E.updatedAt desc`

    let dataResult = await getConnection().query(sql, [
      minorMenu,
      `%${keyword}%`,
    ])
    let countResult = await getConnection().query(sqlCount, [
      minorMenu,
      `%${keyword}%`,
    ])

    let response = new PagingResponse<EntityWithUser>()
    response.total = countResult[0]?.total
    response.data = dataResult

    // 解密 data
    if (response.data && response.data.length > 0) {
      response.data.forEach(it => {
        if (it.dataStr) {
          try {
            it.data = decipher(it.dataStr)
          } catch (ex) {
            logger.error('解密脱敏数据异常：', ex)
          }
        }
      })
    }

    return response
  }

  async getFirstEntitieByUserAndTemplateId(
    userId: number,
    templateId: number,
    orgId: number
  ): Promise<Entity | undefined> {
    return await this.entityRepository.findOne({
      where: {
        templateId,
        status: EntityStatusEnum.已完成,
        orgId: orgId,
        createdBy: {
          id: userId,
        },
      },
      order: { id: 'DESC' },
    })
  }

  async getFirstEntitieByDateRangeAndTemplateId(
    dateRange: number,
    templateId: number,
    orgId: number
  ): Promise<Entity | undefined> {
    return await this.entityRepository.findOne({
      where: {
        templateId,
        orgId,
        dateRange,
        status: EntityStatusEnum.已完成,
      },
      order: { id: 'DESC' },
    })
  }
  async getFirstEntitieByDateRangeAndTemplateIdAndRole(dateRange: number, templateId: number, orgId: number, roleId: number): Promise<Entity | undefined> {
    return await this.entityRepository.findOne({
      where: {
        templateId,
        orgId,
        roleId,
        dateRange,
        status: EntityStatusEnum.已完成,
      },
      order: { id: 'DESC' },
    })
  }

  async getEntitiesByMinorMenu(
    minorMenu: string
  ): Promise<Entity[] | undefined> {
    return await this.entityRepository.find({
      where: {
        minorMenu,
      },
      relations: ['template'],
      order: { id: 'DESC' },
    })
  }

  async getAllEntities(): Promise<Entity[]> {
    return await this.entityRepository.find({ where: { id: MoreThan(0) } })
  }

  async getMissionRecords(
    startDate: Date,
    endDate: Date
  ): Promise<MissionRecord[] | undefined> {
    return await this.missionRecordRepository.find({
      where: { createdAt: Between(startDate, endDate) },
      relations: ['org'],
      order: { id: 'ASC' },
    })
  }
  async getMissionRecordsByDateRange(
    dateRangeType: DateRangeTypeEnum,
    startDate: Date,
    endDate: Date
  ): Promise<MissionRecord[] | undefined> {
    return await this.missionRecordRepository.find({
      where: {
        dateRangeType: dateRangeType,
        createdAt: Between(startDate, endDate),
      },
      relations: ['org'],
      order: { id: 'ASC' },
    })
  }
  async getMissionRecordsByOrgs(
    orgIds: number[],
    startDate: Date,
    endDate: Date
  ): Promise<MissionRecord[] | undefined> {
    return await this.missionRecordRepository.find({
      where: { orgId: In(orgIds), createdAt: Between(startDate, endDate) },
      relations: ['org'],
      order: { id: 'ASC' },
    })
  }
  async getMissionRecordsByOrgsAndDateRangeType(
    orgIds: number[],
    dateRangeType: DateRangeTypeEnum,
    startDate: Date,
    endDate: Date
  ): Promise<MissionRecord[]> {
    return await this.missionRecordRepository.find({
      where: {
        orgId: In(orgIds),
        dateRangeType: dateRangeType,
        // 暂时不限制年份
        // createdAt: Between(startDate, endDate),
      },
      relations: ['org', 'template'],
      order: { id: 'ASC' },
    })
  }

  async createEntity(entity: Entity): Promise<Entity | undefined> {
    try {

      // 加密 data
      if (entity.data) {
        entity.dataStr = cipher(JSON.stringify(entity.data))
      }

      let entityNew = this.entityRepository.create(entity)
      return await this.entityRepository.save(entityNew)
    } catch (ex) {
      logger.error('创建表单异常', ex)
      return undefined
    }
  }

  async updateEntity(userId: number, entityId: number, entity: EntityUpdate) {

    // 加密 data
    if (entity.data) {
      entity.dataStr = cipher(JSON.stringify(entity.data))
    }
    delete entity.data

    return this.entityRepository.update(
      {
        id: entityId,
        createdBy: {
          id: userId,
        },
      },
      entity
    )
  }
  async updateEntityById(entityId: number, entity: EntityUpdate) {
    // 加密 data
    if (entity.data) {
      entity.dataStr = cipher(JSON.stringify(entity.data))
    }
    delete entity.data

    return this.entityRepository.update(
      {
        id: entityId,
      },
      entity
    )
  }

  async deleteEntity(userId: number, entityId: number) {
    return await this.entityRepository.softDelete({
      id: entityId,
      createdById: userId,
    })
  }

  async deleteEntityById(entityId: number) {
    return this.entityRepository.softDelete({
      id: entityId,
    })
  }

  async createMissionRecord(
    missionRecord: CreateMissionRecord
  ): Promise<MissionRecord | undefined> {
    let mission = this.missionRecordRepository.create(missionRecord)
    return await this.missionRecordRepository.save(mission)
  }

  async createMissionRecordBatch(missionRecords: CreateMissionRecord[]) {
    try {
      for (const mission of missionRecords) {
        let insertOne = await this.missionRecordRepository.insert(mission)
      }
    } catch (err) {
      logger.error('err', err)
    }
  }

  async updateMissionRecord(id: number, missionRecord: MissionRecord) {
    return await this.missionRecordRepository.update(
      {
        id,
      },
      missionRecord
    )
  }

  async deleteMissionRecordByEntityId(entityId: number) : Promise<void> {
    this.missionRecordRepository.softDelete({
      entityId,
    })
  }

  async getAssessmentItems(orgId: number, year: number, assessmentType: AssessmentTypeEnum): Promise<AssessmentItem[]> {
    return await this.assessmentItemRepository.find({
      where: {
        orgId: orgId,
        year: year,
        assessmentType: assessmentType,
      },
      order: { id: 'ASC' },
    })
  }

  async deleteAssessmentItemByTemplateKey(templateKey: string, createdById: number) {
    this.assessmentItemRepository.softDelete({
      templateKeys: Like(`%${templateKey}%`),
      createdById,
    })
  }

  async createAssessmentItem(assessmentItem: CreateAssessmentItem): Promise<AssessmentItem | undefined> {
    let item = this.assessmentItemRepository.create(assessmentItem)
    return await this.assessmentItemRepository.save(item)
  }

  async createAssessmentItemBatch(assessmentItems: CreateAssessmentItem[]) {
    try {
      for (const item of assessmentItems) {
        let insertOne = await this.assessmentItemRepository.insert(item)
      }
    } catch (err) {
      logger.error('err', err)
    }
  }

  async updateAssessmentItem(itemId: number, assessmentItem: AssessmentItem): Promise<UpdateResult | undefined> {
    return await this.assessmentItemRepository.update(
      {
        id: itemId,
      },
      assessmentItem
    )
  }


  async createSuperviseRecord(superviseRecord: SuperviseRecord): Promise<SuperviseRecord | undefined> {
    let supervise = this.superviseRecordRepository.create(superviseRecord)
    return await this.superviseRecordRepository.save(supervise)
  }

  async createSuperviseRecordBatch(superviseRecords: SuperviseRecord[]) {

    try {
      for (const supervise of superviseRecords) {
        let insertOne = await this.superviseRecordRepository.insert(supervise)
      }
    } catch (err) {
      logger.error('err', err)
    }
  }

  async deleteSuperviseRecordByEntityId(entityId: number): Promise<void> {
    try {
      this.superviseRecordRepository.softDelete({
        entityId,
      })
    } catch (err) {
      logger.error('err', err)
    }
  }

  async getSuperviseRecords(startDate: Date, endDate: Date): Promise<SuperviseRecord[] | undefined> {
    const startDateStr = moment(startDate).format('YYYY-MM-DD')
    const endDateStr = moment(endDate).format('YYYY-MM-DD')

    let sql = `
      select DISTINCT involveUserId, illegalBehaviorType, orgId, checkedAt
      FROM supervise_record
      where deletedAt is null
      and checkedAt between ? and ?;
    `
    return await getConnection().query(sql, [startDateStr, endDateStr])
  }

  async getSZXTRecords(
    startDate: Date,
    endDate: Date,
    orgIds?: number[],
    createdByIds?: number[],
    templateIds?: number[]
  ): Promise<EntityWithUser[]> {
    const startDateStr = moment(startDate).format('YYYY-MM-DD')
    const endDateStr = moment(endDate).format('YYYY-MM-DD')
    let sql = `
      select E.*,
      U.id as U_id,
      U.name as U_name,
      U.policeId as U_policeId,
      U.orgId as U_orgId,
      U.jobDesc as U_jobDesc,
      U.quater as U_quater,
      UO.name as U_orgName
      from entity as E
        left join user_account U
        on U.id = E.createdById
        left join user_org UO
        on UO.id = U.orgId
        where E.deletedAt is null
        and E.status='${EntityStatusEnum.已完成}'
        and E.completedAt between ? and ?
    `
    if (orgIds && orgIds.length > 0) {
      sql += ` and E.orgId in (${orgIds.join(',')}) `
    }

    if (createdByIds && createdByIds.length > 0) {
      sql += ` and E.createdById in (${createdByIds.join(',')}) `
    }

    if (templateIds && templateIds.length > 0) {
      sql += ` and E.templateId in (${templateIds.join(',')}) `
    }

    sql += ` order by E.updatedAt desc`

    return await getConnection().query(sql, [startDateStr, endDateStr])
  }
}

export default FormService
