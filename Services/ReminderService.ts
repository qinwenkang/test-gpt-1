import { Service } from 'typedi'
import { getConnection, In, Like } from 'typeorm'

import { InjectRepository } from 'typeorm-typedi-extensions'
import ReminderRepository from 'Domain/Repositories/ReminderRepository'

import { IReminderService } from 'Domain/IServices/IReminderService'
import { PagingRequest, PagingResponse } from 'Domain/Entities/PagingEntity'
import { Reminder } from 'models/Reminder'
import ReminderTypeEnum from 'Enums/ReminderTypeEnum'
import { ReminderWithUser } from 'Domain/Entities/ReminderEntity'
import EntityStatusEnum from 'Enums/EntityStatusEnum'

@Service()
class ReminderService implements IReminderService {
  constructor(
    @InjectRepository()
    private reminderRepository: ReminderRepository,
  ) { }

  async createReminder(data: Reminder): Promise<boolean> {
    let reminderNew = this.reminderRepository.create(data)
    return !!(await this.reminderRepository.save(reminderNew))
  }

  async updateReminder(ownerId: number, id: number, isRead: boolean): Promise<boolean> {
    const updateResult = await this.reminderRepository.update({ id: id, ownerId: ownerId }, { isRead: true })
    return updateResult.affected !== undefined && updateResult.affected > 0
  }

  async removeUnStartedReminder(ownerId: number, templateId: number): Promise<void> {
    await this.reminderRepository.delete({ templateId: templateId, ownerId: ownerId, status: EntityStatusEnum.未开始 })
  }

  async removeDrftReminder(ownerId: number, entityId: number): Promise<void> {
    await this.reminderRepository.update({ entityId: entityId, ownerId: ownerId, status: EntityStatusEnum.草稿 }, { isRead: true })
  }

  // 2021年9月27日 需求变更，已完成的表单需要移除提醒事项列表
  async removeCompletedReminder(entityId: number): Promise<void> {
    await this.reminderRepository.update({ entityId: entityId }, { isRead: true, status: EntityStatusEnum.已完成 })
  }

  // 是否已经提醒过了
  async isReminderExist(ownerId: number, conditions: Reminder): Promise<boolean> {
    let isExist = false
    let reminder = await this.reminderRepository.findOne({
      ownerId: ownerId,
      orgId: conditions.orgId,
      majorMenu: conditions.majorMenu,
      minorMenu: conditions.minorMenu,
      reminderType: conditions.reminderType,
      entityId: conditions.entityId,
      templateId: conditions.templateId,
      status: conditions.status,
      createdById: conditions.createdById,
    })

    if (reminder?.id) {
      isExist = true
    }
    return isExist
  }

  // 是否已经提醒过了 模糊对比，不对比 orgId，entityId，status，reminderType
  async isReminderExistSimple(ownerId: number, conditions: Reminder): Promise<boolean> {
    let isExist = false
    let reminder = await this.reminderRepository.findOne({
      ownerId: ownerId,
      majorMenu: conditions.majorMenu,
      minorMenu: conditions.minorMenu,
      templateId: conditions.templateId,
      createdById: conditions.createdById,
    })

    if (reminder?.id) {
      isExist = true
    }
    return isExist
  }

  async getReminders(ownerId: number, keyword: string, paging: PagingRequest, reminderType?: ReminderTypeEnum, orgId?: number): Promise<PagingResponse<ReminderWithUser>> {
    let sqlCount = `
    select count(1) as total
    from reminder as R
      left join user_account U
      on U.id = R.ownerId

      where R.ownerId = ${ownerId}
      and R.isRead = 0
  `
    let sql = `
    select R.*,
    U.id as U_id,
    U.name as U_name,
    U.policeId as U_policeId,
    U.orgId as U_orgId,
    U.jobDesc as U_jobDesc,
    U.quater as U_quater,
    UO.name as U_orgName
    from reminder as R
      left join user_account U
      on U.id = R.ownerId
      left join user_org UO
      on UO.id = U.orgId
      where R.ownerId = ${ownerId}
      and R.isRead = 0
  `

    if (reminderType) {
      sql += ` and R.reminderType = ${reminderType} `
      sqlCount += ` and R.reminderType = ${reminderType} `
    }

    if (orgId) {
      sql += ` and R.orgId = ${orgId} `
      sqlCount += ` and R.orgId = ${orgId} `
    }

    if (keyword != '') {
      sql += ` and R.keywords like ?`
      sqlCount += ` and R.keywords like ?`
    }

    sql += ` order by R.updatedAt desc`
    sql += ` limit ${paging.getTake()} offset ${paging.getSkip()} `

    sqlCount += ` order by R.updatedAt desc`

    let dataResult = await getConnection().query(sql, [`%${keyword}%`]);
    let countResult = await getConnection().query(sqlCount, [`%${keyword}%`]);

    let response = new PagingResponse<ReminderWithUser>()
    response.total = countResult[0]?.total
    response.data = dataResult

    return response
  }
}

export default ReminderService
