//
//  SafariExtensionViewController.swift
//  AlertFilter
//
//  Created by Diatoming on 12/20/17.
//  Copyright © 2017 diatoming.com. All rights reserved.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    @IBOutlet weak var tableView: NSTableView!
    
    static let shared = SafariExtensionViewController()

    var schemeList: Set<String> = Set<String>(UserDefaults.standard.array(forKey: DefaultsKey.schemeList.rawValue) as? [String] ?? []) {
        didSet {
            self.tableView.reloadData()
            UserDefaults.standard.set(Array(schemeList), forKey: DefaultsKey.schemeList.rawValue)
        }
    }
    
    @IBAction func actionAddScheme(_ sender: NSButton) {
        let row = self.schemeList.count
        let indexSet = IndexSet(integer: row)
        tableView.insertRows(at: indexSet, withAnimation: [])
        tableView.selectRowIndexes(indexSet, byExtendingSelection: false)
        tableView.editColumn(0, row: row, with: nil, select: true)
    }
    
    @IBAction func actionRemoveScheme(_ sender: NSButton) {
        tableView.removeRows(at: tableView.selectedRowIndexes, withAnimation: .effectFade)
        updateSchemeList()
    }
    
    @IBAction func dataCellAction(_ sender: NSTextField) {
        updateSchemeList()
    }
    
    /// This method just save the full list once a change happens, not recommend for large data.
    private func updateSchemeList() {
        var list = Set<String>()
        tableView.enumerateAvailableRowViews { (rowView, row) in
            if let cell = rowView.view(atColumn: 0) as? NSTableCellView,
                let scheme = cell.textField?.stringValue {
                list.insert(scheme)
            }
        }
        self.schemeList = list.filter { !$0.trimmingCharacters(in: .whitespaces).isEmpty }
    }
}

extension SafariExtensionViewController: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.schemeList.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "dataCell"), owner: self) as? NSTableCellView
        cell?.textField?.stringValue = Array(self.schemeList).sorted()[safe: row] ?? ""
        
        return cell
    }

}

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
