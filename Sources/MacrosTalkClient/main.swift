import MacrosTalk

let a = 4
let b = 2

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")

@Cased
enum Membership {
    case nonMember
    case user(User, Team)
    case team(Team)
    case company(Company)
}

let myUser = Membership.user(.init(), .init())
let myTeam = Membership.team(.init())

