import macros

proc makeFormedParams(params: NimNode): NimNode =
  result = params
  result.expectKind(nnkFormalParams)
  var n = 0
  while n < result.len:
    if result[n].len > 3:
      let ty = result[n][^2]
      for i in countdown(result[n].len-3, 1):
        result.insert(n+1, newIdentDefs(result[n][i], ty, result[n][^1]))
        result[n].del(i)
    n.inc

proc makeCurriedParams(node: NimNode): NimNode =
  result = node
  result.expectKind(nnkFormalParams)
  if result.len == 2: return
  var tmp = node.copyNimTree()
  tmp.del(1)
  result = newTree(nnkFormalParams, newTree(nnkProcTy, makeCurriedParams(tmp),
      newEmptyNode()), result[1])
  result.expectKind(nnkFormalParams)

proc makeCurriedBodyWithCurriedParams(params, body: NimNode): NimNode =
  result = body
  result.expectKind(nnkStmtList)
  params.expectKind(nnkFormalParams)
  if params[0].kind != nnkProcTy:
    result = nnkReturnStmt.newTree(
      newProc(
        newEmptyNode(),
        [params[0], params[1]],
        body,
        nnkLambda))
  else:
    result = nnkReturnStmt.newTree(
      newProc(
        newEmptyNode(),
        [params[0], params[1]],
        makeCurriedBodyWithCurriedParams(params[0][0], body),
        nnkLambda))

macro curry*(someProc: untyped): untyped =
  result = someProc
  result[3] = result[3].copyNimTree.makeFormedParams.copyNimTree.makeCurriedParams
  result[6] = makeCurriedBodyWithCurriedParams(result[3][0][0], result[6])
