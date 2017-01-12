From: Ken Goldman <kgoldman-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: TPM 2.0 RM getcapability #2
Date: Thu, 12 Jan 2017 10:15:25 -0500
Message-ID: <o586i6$qb$1@blaine.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

The result of getcapability for transient objects should normally be 
virtual handles that the application sees, not the TPM handles.

However, there is a corner case - auditing the getcapability command.

	Audit is a TPM function that maintains a hash of commands
	and responses, and can sign the audit log.

If the command is audited, the application will see different data from 
the TPM (if the getcapability command is even sent to the TPM).  Thus, 
the audit log won't match.

Two solutions:

1 - Detect the audit bit in the session, and don't virtualize the 
command.  Send it to the TPM and return the TPM handles.

2 - Declare that auditing getcapability -> transient objects won't work.

The TSS WG specifies #1.

My feeling is that audit is a dubious use case, and auditing 
getcapability is a very unlikely use case.  I'd go with #2.

Again, what's the sense of the group?  I want to know if I have to 
either (#1) write TSS code or (#2) put an informative comment in the TPM 
library specification.


------------------------------------------------------------------------------
Developer Access Program for Intel Xeon Phi Processors
Access to Intel Xeon Phi processor-based developer platforms.
With one year of Intel Parallel Studio XE.
Training and support from Colfax.
Order your platform today. http://sdm.link/xeonphi
